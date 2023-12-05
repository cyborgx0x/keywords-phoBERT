from fastapi import FastAPI
import uvicorn
from kw import get_keywords
from pydantic import BaseModel

app = FastAPI()
class Task(BaseModel):
    text: str


@app.post("/")
def read_item(task: Task):
    return get_keywords(task.text)
