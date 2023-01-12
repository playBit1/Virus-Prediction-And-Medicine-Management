from flask import Flask, jsonify, request
import ml_model_loader as ml

app = Flask(__name__)


class VirusApiServer:
    app = Flask(__name__)

    # POST method to collect user data and return model output
    @staticmethod
    @app.route('/model', methods=['POST'])
    def post_model():
        data = request.get_json()
        data_name = data['virusName']
        data_list = data['userData']

        model = ml.MlModelLoader(data_name, data_list)
        final_output = model.run_model()

        return jsonify(final_output), 201

    def run(self):
        self.app.run()


if __name__ == '__main__':
    server = VirusApiServer()
    server.run()
