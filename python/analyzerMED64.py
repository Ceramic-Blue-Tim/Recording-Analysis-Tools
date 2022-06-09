import sys
import os
import time
import math
import numpy as np
import pyqtgraph as pg
from scipy import signal
from PyQt5.QtWidgets import (QApplication, QFileDialog)

# Imports #################################################################
# UTILITIES
import sys

# Qt5
from PyQt5.QtWidgets import (QApplication)

# Custom Qt5 GUI
from MainWindow import *

# Launch application #################################################################
if __name__ == "__main__":
    app             = QApplication(sys.argv)
    win             = MainWindow(app)

    # Theme
    app.setStyle('Fusion')

    win.show()
    
    sys.exit(app.exec())