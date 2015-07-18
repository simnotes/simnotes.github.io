#!/bin/bash
cd ~/.ipython/profile_pyspark/
sed -i "/# c.NotebookApp.ip = 'localhost'/c\c.NotebookApp.ip = '*'" ipython_notebook_config.py
sed -i "/# c.NotebookApp.open_browser = True/c\c.NotebookApp.open_browser = False" ipython_notebook_config.py
sed -i "/# c.NotebookApp.port = 8888/c\c.NotebookApp.port = 8889" ipython_notebook_config.py
sed -i "/# c.NotebookApp.notebook_dir = u''/c\c.NotebookApp.notebook_dir = u'/usr/hdp/2.3.0.0-2130/spark/'" 
ipython_notebook_config.py