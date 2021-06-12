from sklearn.preprocessing import LabelEncoder
from sklearn.svm import SVC
import pickle
def training():
    embeddingFile = "output/embeddings.pickle"

    recognizerFile = "output/recognizer.pickle"
    labelEncFile = "output/le.pickle"

    data = pickle.loads(open(embeddingFile,"rb").read())

    labelEnc = LabelEncoder()
    labels = labelEnc.fit_transform(data["names"])


    recognizer = SVC(C=1.0, kernel = "linear", probability = True)
    recognizer.fit(data["embeddings"],labels)

    f = open(recognizerFile, "wb")
    f.write(pickle.dumps(recognizer))
    f.close()

    f = open(labelEncFile, "wb")
    f.write(pickle.dumps(labelEnc))
    f.close()


