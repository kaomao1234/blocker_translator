import easyocr

reader = easyocr.Reader(lang_list=['en'])
text = reader.readtext("C:/Github/blocker_translator/lib/backend/logic/capture.png",detail=0)
print(text)