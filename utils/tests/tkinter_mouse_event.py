import tkinter as tk # this is in python 3.4. For python 2.x import Tkinter
from PIL import Image, ImageTk



class ExampleApp(tk.Tk):
    def __init__(self):
        tk.Tk.__init__(self)
        self.x = self.y = 0
        self.canvas = tk.Canvas(self, width=512, height=512, cursor="cross")
        self.canvas.pack(side="top", fill="both", expand=True)
        self.canvas.bind("<ButtonPress-1>", self.on_button_press)
        self.canvas.bind("<B1-Motion>", self.on_move_press)
        self.canvas.bind("<ButtonRelease-1>", self.on_button_release)

        self.rect = None

        self.start_x = None
        self.start_y = None


        self._draw_image()


    def _draw_image(self):
         self.im = Image.open('./resource/lena.jpg')
         self.tk_im = ImageTk.PhotoImage(self.im)
         self.canvas.create_image(0,0,anchor="nw",image=self.tk_im)



    def on_button_press(self, event):
        # save mouse drag start position
        self.start_x = event.x
        self.start_y = event.y

        # create rectangle if not yet exist
        #if not self.rect:
        self.rect = self.canvas.create_rectangle(self.x, self.y, 1, 1, fill="black")

    def on_move_press(self, event):
        curX, curY = (event.x, event.y)

        # expand rectangle as you drag the mouse
        self.canvas.coords(self.rect, self.start_x, self.start_y, curX, curY)



    def on_button_release(self, event):
        pass


if __name__ == "__main__":
    app = ExampleApp()
    app.mainloop()