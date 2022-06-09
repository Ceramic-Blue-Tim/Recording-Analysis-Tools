# Utilities
import math
import os
import numpy as np
from scipy import signal
import pyqtgraph as pg

# Qt
from PyQt5.QtWidgets import (QApplication, QDialog, QMainWindow, QMessageBox, QFileDialog, QTreeWidgetItem)
from PyQt5 import QtGui
from PyQt5.QtCore import Qt

# Qt designed ui
from main_window_ui import Ui_MainWindow

NB_CHANNELS = 64
FS          = 20000
DURATION    = 60*1
NB_SAMPLES  = FS*DURATION

def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = signal.butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = signal.lfilter(b, a, data)
    return y

# Main window gui actions #################################################################
class MainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self, app: QApplication):
        """Initialize main window ui and variables
        
        :param Window self: Main window gui
        :param QApplication app: application
        """
        super().__init__()
        self.setupUi(self)
        self.app            = app
        self.nb_plots       = NB_CHANNELS
        self.gwin           = pg.GraphicsWindow()
        self.plots          = []
        self.t              = []
        self.edata          = []
        
        self.val_yMax.setDecimals(0)
        self.val_yMax.setMaximum(65535.0)
        self.val_yMax.setMinimum(-65535.0)
        self.val_yMin.setDecimals(0)
        self.val_yMin.setMaximum(65535.0)
        self.val_yMin.setMinimum(-65535.0)
        self.val_tstart.setMaximum(2147483647)
        self.val_tstart.setMinimum(0)
        self.val_duration.setMaximum(2147483647)
        self.val_duration.setMinimum(0)

        self.box_filter_lowcut.setMaximum(1000)
        self.box_filter_highcut.setMaximum(20000)
        self.box_filter_order.setMaximum(7)

        self.connectSignalsSlots()
        self.initTreeSelElec()

    def connectSignalsSlots(self):
        self.btn_load_rec.clicked.connect(self.loadBinFile)
        self.btn_plot_rec.clicked.connect(self.plotRec)

    def loadBinFile(self):
        dialog              = QFileDialog()
        [fpath_bin, _]      = dialog.getOpenFileName(dialog, "Recording file to analyze", ".bin")
        [dir_path, _]       = os.path.split(fpath_bin)
        [fname_no_ext, _]   = os.path.splitext(os.path.basename(fpath_bin))
        fpath_hdr           = os.path.join(dir_path, fname_no_ext + ".hdr")
        # print("fpath_bin : " + fpath_bin + "\n")
        # print("fpath_hdr : " + fpath_hdr + "\n")
        self.dispRecName(fname_no_ext)

        nb_samples  = int(os.path.getsize(fpath_bin)/2)
        self.t      = np.linspace(0, nb_samples/FS, int(nb_samples/NB_CHANNELS), endpoint=False)
        self.edata  = np.fromfile(fpath_bin, dtype=np.int16, count=nb_samples)
        self.edata  = np.reshape(self.edata, (int(nb_samples/NB_CHANNELS), NB_CHANNELS))

    def plotClear(self):
        self.gwin.clear()
        self.plots.clear()

    def plotRec(self):
        # Init plots
        self.plotClear()

        # Get electrodes to plot
        item_list = self.get_selected_leaves()
        self.nb_plots = len(item_list)
        max_row = round(math.sqrt(self.nb_plots))
        max_col = math.ceil(math.sqrt(self.nb_plots))
        offset  = 1

        for row_id in range(max_row):
            for col_id in range(max_col):
                index = row_id*max_col+col_id
                self.plots.append(self.gwin.addPlot(row=row_id, col=col_id, title=item_list[index]))

        for i in range(self.nb_plots):
            if self.en_filter.isChecked():
                lowcut  = self.box_filter_lowcut.value()
                highcut = self.box_filter_highcut.value()
                order   = self.box_filter_order.value()
                y = butter_bandpass_filter(self.edata[:, int(item_list[i])-1], lowcut, highcut, FS, order)
                if self.en_tstart.isChecked() and not(self.en_duration.isChecked()):
                    tstart = self.val_tstart.value()*FS
                    self.plots[i].plot(self.t[tstart::], y[tstart::])
                elif not(self.en_tstart.isChecked()) and self.en_duration.isChecked():
                    nb_samples = self.val_duration.value()*FS
                    self.plots[i].plot(self.t[0:nb_samples], y[0:nb_samples])
                elif self.en_tstart.isChecked() and self.en_duration.isChecked():
                    tstart = self.val_tstart.value()*FS
                    nb_samples = self.val_duration.value()*FS
                    self.plots[i].plot(self.t[tstart:tstart+nb_samples], y[tstart:tstart+nb_samples])
                else:
                    self.plots[i].plot(self.t, y[:])
            else:
                if self.en_tstart.isChecked() and not(self.en_duration.isChecked()):
                    tstart = self.val_tstart.value()*FS
                    self.plots[i].plot(self.t[tstart::], self.edata[tstart::, int(item_list[i])-1])
                elif not(self.en_tstart.isChecked()) and self.en_duration.isChecked():
                    nb_samples = self.val_duration.value()*FS
                    self.plots[i].plot(self.t[0:nb_samples], self.edata[0:nb_samples, int(item_list[i])-1])
                elif self.en_tstart.isChecked() and self.en_duration.isChecked():
                    tstart = self.val_tstart.value()*FS
                    nb_samples = self.val_duration.value()*FS
                    self.plots[i].plot(self.t[tstart:tstart+nb_samples], self.edata[tstart:tstart+nb_samples, int(item_list[i])-1])
                else:
                    self.plots[i].plot(self.t, self.edata[:, int(item_list[i])-1])
            
            # Set Y limits
            if self.en_yMin.isChecked():
                self.plots[i].setLimits(yMin=self.val_yMin.value())
            if self.en_yMax.isChecked():
                self.plots[i].setLimits(yMax=self.val_yMax.value())

    def dispRecName(self, fname):
        self.line_fname.setText(fname)

    def initTreeSelElec(self):
        label = ["upper left", "upper right", "lower left", "lower right"]
        self.tree_sel_elec.setHeaderLabel("Electrodes to display")
        for i in range(4):
            p = QTreeWidgetItem(self.tree_sel_elec)
            p.setText(0, label[i])
            p.setFlags(p.flags() | Qt.ItemIsTristate | Qt.ItemIsUserCheckable)
            p.setCheckState(0, Qt.Unchecked)
            for j in range(16):
                child = QTreeWidgetItem(p)
                child.setFlags(child.flags() | Qt.ItemIsUserCheckable)
                child.setText(0, "{}".format(j+i*16+1))
                child.setCheckState(0, Qt.Unchecked)

    def get_selected_leaves(self):
        checked_items = []
        def recurse(parent_item):
            for i in range(parent_item.childCount()):
                child = parent_item.child(i)
                grand_children = child.childCount()
                if grand_children > 0:
                    recurse(child)
                else: 
                    if child.checkState(0) == Qt.Checked:
                        checked_items.append(child.text(0))

        recurse(self.tree_sel_elec.invisibleRootItem())
        return checked_items