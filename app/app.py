from flask import Flask, jsonify, request
from rubikscubetracker import  RubiksImage
import json
import helpers 

app = Flask(__name__)

prominent_color_palette = {
    'red'   : (0, 0, 255),
    'orange': (0, 165, 255),
    'blue'  : (255, 0, 0),
    'green' : (0, 255, 0),
    'white' : (255, 255, 255),
    'yellow': (0, 255, 255)
}
calibrated_colors = {}
notations = {}
cubestring = {}

@app.route('/calibrate',methods=["POST"])
def calibrate():
  file = request.files['image']
  file.save(file.filename)
  payload = request.form.to_dict()
  color = payload['color']
  side = payload['side']
  try:
    rimg = RubiksImage()
    rimg.analyze_file(file.filename)
    middle_square_color = rimg.data[5]
    calibrated_colors[color] = middle_square_color
    notations[color] = side
    return jsonify({'msg':"%s color has been calibrated successfully"%color})
    #return jsonify({'msg':'success, %s has been calibrated'%coloor,'result':json.dumps(calibrated_colors),'notation':json.dumps(notations)})
  except:
    return jsonify({"status":False,"message":"unable to detect colors, try again..."})


@app.route('/colors',methods=["POST"])
def notation():
  file = request.files['image']
  file.save(file.filename)
  payload = request.form.to_dict()
  side = payload['side']
  try:
    rimg = RubiksImage()
    rimg.analyze_file(file.filename)
    colors_for_side = {}
    sidenot = ""
    if calibrated_colors:
        color_pallete = calibrated_colors
    else:
        color_pallete = prominent_color_palette
    for key,value in rimg.data.items():
      color_name = helpers.get_closest_color(value,color_pallete)
      colors_for_side[key] = color_name['color_name']
      #cubestring[key] = notations[color_name['color_name']]
      sidenot = sidenot + notations[color_name['color_name']]
    cubestring[side] = sidenot
    
    
    return jsonify({'msg':'success','side':side,'result':json.dumps(colors_for_side)})
  except:
    return jsonify({"status":False,"message":"Error"})

@app.route('/result', methods=['GET','POST'])
def solve():
    resultstring = ""
    for sidename in ("Up","Right","Front","Down","Left","Back"):
        resultstring += cubestring[sidename]
    return jsonify({'result': resultstring})

@app.route('/resetapp', methods=['POST'])
def reset_app():
   calibrated_colors.clear()
   notations.clear()
   cubestring.clear() 
   return jsonify({'msg':'Reset Successful'})


if __name__ == '__main__':
  app.run(host='127.0.0.1', port=8000, debug=True)
 