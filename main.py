from fastapi import FastAPI

app = FastAPI()
from kw import get_keywords


@app.post("/")
def read_item(item: str):
    return get_keywords(item)
