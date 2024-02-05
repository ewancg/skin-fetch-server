from flask import Flask, send_file
import os

app = Flask(__name__)


@app.errorhandler(404)
def not_found(e):
    return ("<p>Skin or page not found ({path}).</p>").format(path=e), 404


@app.route("/list")
def list():
    skinpath = os.path.join(app.root_path + "/skins")
    files = [
        f for f in os.listdir(skinpath) if os.path.isfile(os.path.join(skinpath, f))
    ]
    return ("<p>{count} skins</p><code>{list}</code>").format(
        count=len(files), list=("<br>").join(sorted(files))
    )


@app.route("/")
def info():
    return "<p>Search for a skin by providing a filename.</p>"


@app.route("/<skin>")
def find(skin):
    if not skin.endswith(".png"):
        skin += ".png"
    skin = os.path.join("skins/" + skin)
    if not os.path.isfile(os.path.join(app.root_path, skin)):
        return not_found(skin)
    return send_file(skin)
