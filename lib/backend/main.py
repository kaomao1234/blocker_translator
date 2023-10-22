from mss import mss
import uvicorn
from fastapi import FastAPI, responses
import ctypes
from PIL import Image, ImageFilter, ImageOps
import numpy as np
from pydantic import BaseModel
import cv2
import screen_ocr
import easyocr


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
        self.blocker_model: Rectangle = None
        self.blocker_text: str = None
        self.regiones_text: str = None
        user32 = ctypes.windll.user32
        self.screensize = user32.GetSystemMetrics(
            0), user32.GetSystemMetrics(1)

    def rgb2gray(self, rgb):
        return np.dot(rgb[..., :3], [0.2989, 0.5870, 0.1140])

    def get_frame(self):
        frame = np.random.randint(
            low=0, high=255, size=(480, 640, 3), dtype='uint8')
        encodedImage = cv2.imencode('.png', frame)[1]
        yield (encodedImage.tobytes())

    def blocker_capture(self):
        mons_res = self.blocker_model.toDict()
        sct = mss()
        screenshot = sct.grab(mons_res)
        img = Image.frombytes(
            "RGB", (screenshot.width, screenshot.height), screenshot.rgb)
        array_image = np.array(img, dtype="uint8")
        array_image = np.flip(array_image, axis=2)
        return array_image

    def encodedToPng(image_array: np.ndarray):
        return cv2.imencode(".png", image_array)[1]

    def image_to_text(self, image_array: np.ndarray):
        img = Image.fromarray(image_array)
        img = img.filter(ImageFilter.DETAIL)
        # this needs to run only once to load the model into memory
        ocr_reader = screen_ocr.Reader.create_quality_reader()
        text = ocr_reader.read_image(image=img).as_string()
        return text

    def run(self):
        @self.app.post("/region_dectector")
        async def set_region_detector(rectangle: Rectangle):
            bottom = rectangle.top + rectangle.height
            right = rectangle.left + rectangle.width
            blocker_image = self.blocker_capture()
            cropped_array = blocker_image[rectangle.top:bottom,
                                          rectangle.left:right]
            self.regiones_text = self.image_to_text(cropped_array)
            return rectangle.toDict()

        @self.app.get("/region_detector")
        async def region_image_reading():
            return self.regiones_text

        @self.app.post("/blocker_detector")
        async def set_blocker_detector(rectangle: Rectangle):
            self.blocker_model = rectangle
            return self.blocker_model.toDict()

        @self.app.get("/blocker_detector")
        async def blocker_image_reading():
            image = self.blocker_capture()
            text = self.image_to_text(image_array=image)
            return text

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
