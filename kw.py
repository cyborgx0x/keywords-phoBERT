import numpy as np
from scipy.spatial.distance import cosine
from sentence_transformers import SentenceTransformer
from underthesea import pos_tag

model = SentenceTransformer("phoBERT_sentence")


def get_similarity(text):
    """
    # Điểm tương đồng dựa theo cosine similarity
    Embedding Token được xây dựng dựa trên phoBERT sentence
    """
    corpus_embeddings = model.encode(text)
    similarity = 1 - cosine(corpus_embeddings[0], corpus_embeddings[1])
    return similarity, text[0]


def sorted_key(x):
    return x[0]


def filter_lower(x):
    return x[0] > 0.1


def get_keywords(vietnamese_text):
    tags = pos_tag(vietnamese_text)

    # Extract keywords based on certain criteria (e.g., nouns and adjectives)
    keywords = [word for word, tag in tags if tag.startswith(("N", "A"))]

    # Print the extracted keywords
    print("Keywords:", keywords)
    # keywords = [i.lower() for i in keywords]
    keywords = [i.replace(".", "") for i in keywords]
    keywords = list(set(keywords))
    data = list(map(lambda x: get_similarity([x, vietnamese_text]), keywords))
    keywords = sorted(data, key=sorted_key, reverse=True)
    keywords = list(filter(filter_lower, keywords))
    return keywords
