FROM python:3.10

RUN apt update
RUN apt install -y default-jre


WORKDIR /code

RUN pip install torch==2.1.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install transformers
RUN pip install vncorenlp
RUN pip install fairseq
RUN pip install fastbpe
RUN pip install fastapi
RUN pip install uvicorn
RUN pip install pyngrok
RUN pip install pyyaml
RUN pip install numpy
RUN pip install scipy
RUN pip install "uvicorn[standard]"
RUN mkdir -p /vncorenlp/models/wordsegmenter

RUN wget -q --show-progress https://raw.githubusercontent.com/vncorenlp/VnCoreNLP/master/VnCoreNLP-1.1.1.jar

RUN wget -q --show-progress https://raw.githubusercontent.com/vncorenlp/VnCoreNLP/master/models/wordsegmenter/vi-vocab

RUN wget -q --show-progress https://raw.githubusercontent.com/vncorenlp/VnCoreNLP/master/models/wordsegmenter/wordsegmenter.rdr

RUN mv VnCoreNLP-1.1.1.jar /vncorenlp/

RUN mv vi-vocab /vncorenlp/models/wordsegmenter/

RUN mv wordsegmenter.rdr /vncorenlp/models/wordsegmenter/

RUN git clone https://github.com/DatCanCode/sentence-transformers
WORKDIR /code/sentence-transformers
RUN pip install -e .
RUN pip install underthesea
WORKDIR /code/
COPY phoBERT_sentence /code/phoBERT_sentence
COPY bpe /code/bpe
COPY kw.py /code/
COPY main.py /code/


COPY entry.sh /code/
RUN chmod +x /code/entry.sh
EXPOSE 8000
CMD [ "uvicorn", "main:app", "--port",  "8000", "--host", "0.0.0.0" ]
