# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Click//Play upcounter v0.02
# Developed in 2015 by Guevara-chan
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import System.Windows.Forms
import System.Drawing
import System.Media
import System.IO
import System

#.{ [Classes]
class ExLabel(Label):
	property Gist = ""
	property shifter = 0
	property dbg as bool

	# --Methods goes here.
	def constructor(parent_form as Form):
		TextAlign 	= ContentAlignment.MiddleCenter
		BackColor	= parent_form.ForeColor
		ForeColor	= parent_form.BackColor
		AutoSize	= true
		parent_form.Controls.Add(self)

	def shift(step as int):
		shifter = (shifter + step) % (gist_width)

	def unpack_gist():
		Text = Gist * (parent_width / gist_width + 4)

	def invert():
		ForeColor, BackColor = BackColor, ForeColor

	def locate(x_dest as int, y_dest as int):
		Location = Point(x_dest, y_dest)

	gist_width as int:
		get: return CreateGraphics().MeasureString(Gist, Font).Width

	parent_width as int:
		get: return FindForm().Width

	center_x as int:
		get: return (parent_width - Width) / 2

	center_y as int:
		get: return (FindForm().Height - Height) / 2
# -------------------- #
class SUI:
	sound_box = {}

	# --Methods goes here.
	def constructor():
		asm = System.Reflection.Assembly.GetExecutingAssembly()
		add("inc"	, asm.GetManifestResourceStream("inc_sound"))
		add("dec"	, asm.GetManifestResourceStream("dec_sound"))
		add("null"	, asm.GetManifestResourceStream("null_sound"))

	def add(id as string, src as Stream):
		sound_box[id] = SoundPlayer(src)

	def play(id as string):
		(sound_box[id] cast SoundPlayer).Play()
# -------------------- #
class GUI:
	final win 			= Form(FormBorderStyle: FormBorderStyle.None, WindowState: FormWindowState.Maximized, 
		BackColor: ColorTranslator.FromHtml("#0F0F0F"), ForeColor: Color.Gold)
	final counter 		= ExLabel(win)
	final left_mark		= ExLabel(win, Text: "⋮<clicks>⋮")
	final right_mark 	= ExLabel(win, Text: "⋮</clicks>⋮")
	final add_mark		= ExLabel(win, Gist: "| Left click to add |")
	final sub_mark		= ExLabel(win, Gist: "| Right click to sub |")
	final title			= ExLabel(win, Text: "=[Click//Play upcounter v0.02]=")
	final copyright		= ExLabel(win, Text: "{...Developed in 2015 by V.A. Guevara...}")
	final esc_mark		= ExLabel(win, Gist: "| ESC to exit |")
	final del_mark		= ExLabel(win, Gist: "| DEL to null |")
	final repeater		= System.Timers.Timer(50)
	final sound_box		= SUI()
	accum = 0; shift = 0

	# --Methods goes here.
	def constructor():
		repeater.Elapsed += sync
		repeater.Start()
		# -
		win.MouseClick			+= click_play
		win.MouseDoubleClick	+= click_play
		win.KeyUp				+= escapism
		for label as Control in win.Controls:
			label.MouseClick		+= click_play
			label.MouseDoubleClick	+= click_play
		# -
		copyright.invert()
		title.invert()
		# -
		win.Text = "=[Click//Play]="
		sync(null, null)
		win.ShowDialog()

	def sync(sender, e as System.Timers.ElapsedEventArgs):
		main_font	= Font("Palatino Linotype", win.Height / 42, FontStyle.Bold)
		tag_font	= Font(main_font.FontFamily, main_font.Size - 5, FontStyle.Bold)
		rem_font	= Font(main_font.FontFamily, main_font.Size / 3, FontStyle.Bold)
		# -
		counter.Text 	= "『 $(accum.ToString()) 』"
		counter.Font 	= main_font
		counter.locate	(counter.center_x, counter.center_y)
		# -
		left_mark.Font 		= tag_font; right_mark.Font	= tag_font
		left_mark.locate	(counter.Location.X - left_mark.Width - 5, left_mark.center_y)
		right_mark.locate	(counter.Location.X + counter.Width + 5, right_mark.center_y)
		# - 
		add_mark.Font 	= rem_font; sub_mark.Font 	= rem_font
		esc_mark.Font	= rem_font; del_mark.Font	= rem_font
		copyright.Font	= tag_font; title.Font		= tag_font
		# -
		add_mark.unpack_gist()	; sub_mark.unpack_gist(); esc_mark.unpack_gist(); del_mark.unpack_gist()
		add_mark.shift(1)		; sub_mark.shift(1)  	; esc_mark.shift(1)		; del_mark.shift(1)
				# -
		add_mark.locate	(add_mark.center_x + add_mark.shifter, counter.Location.Y - add_mark.Height - 30)
		sub_mark.locate	(sub_mark.center_x - sub_mark.shifter, counter.Location.Y + counter.Height + 30)
		title.locate	(title.center_x, add_mark.Location.Y - title.Height)
		copyright.locate(copyright.center_x, sub_mark.Location.Y + sub_mark.Height)
		esc_mark.locate	(esc_mark.center_x - esc_mark.shifter, title.Location.Y - esc_mark.Height)
		del_mark.locate	(del_mark.center_x + del_mark.shifter, copyright.Location.Y + copyright.Height)		

	def click_play(sender, e as MouseEventArgs):
		if e.Button == MouseButtons.Right:
			if accum: sound_box.play("dec"); accum -= 1
		else:
			sound_box.play("inc"); accum += 1	

	def escapism(sender, e as KeyEventArgs):
		if		e.KeyCode == Keys.Escape: Application.Exit()
		elif	e.KeyCode == Keys.Delete:
			if accum: sound_box.play("null"); accum = 0; 
#.}

# -Main code goes here:
GUI()