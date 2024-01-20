import easyocr

reader = easyocr.Reader(lang_list=['en'],gpu=True)
text = reader.readtext("C:/Github/blocker_translator/lib/backend/logic/ImageFilter_blur.png",detail=0)
print(text)