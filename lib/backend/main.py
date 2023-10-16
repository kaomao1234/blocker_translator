from mss import mss
import uvicorn
from fastapi import FastAPI, responses
import ctypes
from PIL import Image,ImageFilter
import numpy as np
from pydantic import BaseModel
import cv2
import pytesseract
import screen_ocr


class Rectangle(BaseModel):
    left:  int
    top: int
    width: int
    height: int

    def toDict(self):
        return {
            "left": self.left,
            "top": self.top,
            "width": self.width,
            "height": self.height
        }


class Server():
    def __init__(self) -> None:
        self.app = FastAPI()
        self.count = 0
        self.store_rectangle: Rectangle = None
        self.store_image: np.ndarray = None
        user32 = ctypes.windll.user32
        self.screensize = user32.GetSystemMetrics(
            0), user32.GetSystemMetrics(1)
        
    def rgb2gray(self,rgb):
        return np.dot(rgb[...,:3], [0.2989, 0.5870, 0.1140])

    def get_frame(self):
        frame = np.random.randint(
            low=0, high=255, size=(480, 640, 3), dtype='uint8')
        encodedImage = cv2.imencode('.png', frame)[1]
        yield (encodedImage.tobytes())

    def blocker_capture(self):
        mons_res = self.store_rectangle.toDict()
        sct = mss()
        screenshot = sct.grab(mons_res)
        img = Image.frombytes(
            "RGB", (screenshot.width, screenshot.height), screenshot.rgb)
        array_image = np.array(img, dtype="uint8")
        array_image = np.flip(array_image, axis=2)
        self.store_image = array_image
        encodedImage = cv2.imencode(".png", array_image)[1]
        yield (encodedImage.tobytes())

    def image_to_text(self):
        ocr_reader = screen_ocr.Reader.create_quality_reader()
        
        img = Image.fromarray(self.store_image)
        text = ocr_reader.read_image(image=img).as_string()
        return text

    def run(self):
        @self.app.get('/text_from_image')
        async def text_from_cur_image():
            return self.image_to_text()

        @self.app.post("/blocker_capture")
        async def set_blocker_capture(rectangle: Rectangle):
            self.store_rectangle = rectangle
            return self.store_rectangle.toDict()

        @self.app.get("/blocker_capture")
        async def blocker_capture_feed():
            return responses.StreamingResponse(self.blocker_capture())

        @self.app.get("/frame")
        async def frame():
            return responses.StreamingResponse(self.get_frame())

        @self.app.get("/")
        async def root():
            self.count += 1
            return "hello my api {}".format(self.count)


server = Server()
app = server.app
server.run()
