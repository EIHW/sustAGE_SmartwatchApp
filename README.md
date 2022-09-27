# The sustAGE smartwatch app and back-end server for data transmission and reception

This repository provides the source code of the smartwatch app developed in the context of the sustAGE project, implemented for and deployed in a Garmin Vivoactive 3 device. Herein, we also provide the source code of the server implemented to receive and handle the data transmitted from the smartwatch.

## Back-end server

The code corresponding to the back-end server is located in the `server` directory. 

### General Installation Instructions

#### Linux
If you have conda installed (either miniconda or anaconda), you can execute
```bash
conda env create -f server/.env-ymls/ServerEnv.yml
```
to setup the virtual environment required to execute the Flask-based Python server. You can activate the `ServerEnv` environment with 
```bash
source ./activate ServerEnv
```

### Source code
`src` contains the Flask-based Python scripts implemented to run the server. It also contains the sample Python script provided to retrieve the sensor data received from the smartwatch.

Line 76 of the `server/src/app.py` script defines the IP and the port number enabled for the data transmission. Users aiming to use this repository might need to update these parameters according to their own deployment infrastructure. 

### Execution instructions

To launch the back-end server, please execute the following command: 

```bash
python server/src/app.py 
```

To retrieve the sensor data received from the smartwatch, we provide the `server/src/watchModule.py` sample script. Before executing the script, users might need to update the URL of the back-end server in line 10 of the `server/src/watchModule.py` script. After this update, the received data can be retrieved by executing the following command in a new terminal window: 

```bash
python server/src/watchModule.py
````

## Smartwatch app

The source code of the smartwatch app is located in the `app` directory. 

To use the provided app off-the-shelf, users just need to update the `ip` and `port` number information in the line 15 of the `app/source/sustAGEApp.mc` script. The `ip` and `port` number must match the IP and port number enabled before the execution of the back-end Flask-based Python server. 

## Citation
If you use the code from this repository, you are kindly asked to cite the following paper:

> Adria Mallol-Ragolta, Anastasia Semertzidou, Maria Pateraki, and Björn Schuller, “harAGE: A Novel Multimodal Smartwatch-based Dataset for Human Activity Recognition,” in *Proceedings of the 16th International Conference on Automatic Face and Gesture Recognition*, (Jodhpur, India – Virtual Event), IEEE, 2021.

```
@inproceedings{Mallol-Ragolta21-HAN,
  author = {Adria Mallol-Ragolta and Anastasia Semertzidou and Maria Pateraki and Björn Schuller},
  title = {{harAGE: A Novel Multimodal Smartwatch-based Dataset for Human Activity Recognition}}, 
  booktitle = {{Proceedings of the 16th International Conference on Automatic Face and Gesture Recognition}}, 
  year = {2021},
  editor = {},
  volume = {},
  series = {},
  pages = {},
  address = {Jodhpur, India -- Virtual Event},
  month = {December},
  organization = {IEEE},
  publisher = {IEEE},
  note = {7 pages},
}
```

## License
The code in this repository is released under the MIT License.

## Acknowledgements

The implementation of the Garmin smartwatch app and the required infrastructure has received funding from the European Union's Horizon 2020 research and innovation programme under grant agreement No. 826506 (sustAGE).
