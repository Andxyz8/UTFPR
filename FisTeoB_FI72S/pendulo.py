import cv2 as opencv
from scipy import ndimage
import PyGnuplot as gnu
import os as sistema
import numpy as np

################FUNÇÕES################

#Exibe uma imagem e espera por uma tecla
def exibirImagem (img, tit = "Imagem",):
	opencv.imshow(tit, img)
	
	#Grava um arquivo da imagem em disco
	#opencv.imwrite(DIRETORIO + "frame"+str(cont)+".png", img)
	
	opencv.moveWindow(tit, 300, 100);
	
	if(opencv.waitKey() & 0xFF == ord('q')):
		opencv.destroyWindow(tit)
		return False
	else:
		opencv.destroyWindow(tit)
		return True


#Grava a posição do pendulo no espaço em função do tempo em um arquivo
def gravaPosicao(img, t):
	arquivo = open(DIRETORIO+"posicao.txt", 'a')
	somatorioPosX = 0
	qtd = 0
	
	for i in range(img.shape[1]):
		for j in range(img.shape[0]):
			if(img[j][i] == 0):
				somatorioPosX = somatorioPosX+i
				qtd = qtd+1

	arquivo.write(str(t) + " " + str((FATOR*somatorioPosX/qtd)-3.71) + "\n")
	arquivo.close()
	

def processaFrame(frame):
	frame = ndimage.rotate(frame, -90)
	
	recorte = frame[650:frame.shape[0], frame.shape[1]//30:(frame.shape[1]-frame.shape[1]//9)]

	#Escala de cinza
	frame_processado = opencv.cvtColor(recorte, opencv.COLOR_BGR2GRAY)

	#Desfoque
	frame_processado = opencv.medianBlur(frame_processado, 7)
	
	#Binarização
	_, frame_processado = opencv.threshold(frame_processado, 85, 255, 0)
	exibirImagem(frame_processado, "BINARIZADA")

	return frame_processado

def usandoGnuPlot():
	gnu.c("set term wxt enhanced")
	gnu.c("set title 'OSCILADOR HARMÔNICO AMORTECIDO'")
	gnu.c("set xlabel 't (s)'")
	gnu.c("set ylabel 'x (cm)'")
	gnu.c("f(x) = A + B*exp(-b*x)*cos(w*x-c)")
	gnu.c("fit [0:60] [-5:5] f(x) 'posicao.txt' via A, B, b, w, c")
	gnu.c("set samples 1802")
	gnu.c("plot [0:60] [-5:5] 'posicao.txt' title 'Posições' lc rgb 'black', f(x) lc rgb 'red'")
	gnu.c("set print 'resultado.txt'")
	gnu.c("print b")
	gnu.c("print w")
	gnu.c("set term postscript")
	gnu.c("set output 'grafico.ps'")
	gnu.c("set term png size 1280, 720")
	gnu.c("set output 'grafico.png'")
	gnu.c("replot")
	gnu.c("set term win")

def calculaFatorQualidade():
	resultados  = np.genfromtxt("resultado.txt")
	w = resultados[1]
	b = resultados[0]
	
	Q = np.sqrt((w*w)-(b*b))/(2*b)
	
	if(sistema.path.exists(DIRETORIO+"fatorQualidade.txt")):
		sistema.remove(DIRETORIO+"fatorQualidade.txt")
		
	arq = open(DIRETORIO+"fatorQualidade.txt", 'a+')
	arq.write(str(Q))
	arq.close()
		

################DEFINIÇÕES E VARIAVEIS################
DIRETORIO = "C:/Users/ander/Desktop/Projeto Pendulo/"
FPS = 30
tempo = -1/30


FATOR = 7/427

#Carrega o video
'''video = opencv.VideoCapture("Video.mp4")

if(sistema.path.exists(DIRETORIO+"posicao.txt")):
	sistema.remove(DIRETORIO+"posicao.txt")
	arquivo = open(DIRETORIO+"posicao.txt", 'a+')
	arquivo.close()

#Caso dê erro no carregamento do vídeo, etc
if(not video.isOpened()):
	print("Não foi possível abrir o vídeo.")
	exit(0)

for i in range(25):
	verif, frame = video.read()

#LEITURA FRAME-A-FRAME
while(tempo <= 60):
	verif, frame = video.read()
	
	tempo = tempo+1/FPS
	
	frame = processaFrame(frame)
	
	gravaPosicao(frame, tempo)

video.release()'''

usandoGnuPlot()

calculaFatorQualidade()
