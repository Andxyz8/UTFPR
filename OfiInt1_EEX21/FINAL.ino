//Define a porta e a biblioteca do servo
#include <Servo.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#define SERVO_CENTRO 5	 // Porta Digital 5 PWM
#define SERVO_ESQUERDA 6 // Porta Digital 6 PWM
#define SERVO_DIREITA 7	 // Porta Digital 7 PWM

//Declaração do LCD junto com o módulo I2C
LiquidCrystal_I2C lcd(0x27, 16, 2);

//Declaração das variaveis dos servo motores
Servo servoCentro;	  // Variável Servo do Centro
int posServoCentro;	  // Posição Servo do Centro
Servo servoEsquerda;  // Variável Servo da Esquerda
int posServoEsquerda; // Posição Servo da Esquerda
Servo servoDireita;	  // Variável Servo da Direita
int posServoDireita;  // Posição Servo da Direita

//Definição dos pinos do Arduino ligados à entrada da Ponte H
int IN1 = 3;
int IN2 = 4;

//Pinos de conexão do SENSOR DE COR TCS3200
const int s0 = 8;
const int s1 = 9;
const int s2 = 12;
const int s3 = 11;
const int out = 10;

//Variaveis dos parâmetros RGB das cores
int red = 0;
int green = 0;
int blue = 0;

//Variaveis indicadoras das cores: Nenhuma cor; Vermelho; Azul; Amarelo.
String strCor = "Nenhuma cor";

//Variáveis contadores da quantidade de esferas que passou
int contadorVermelho = 0;
int contadorAzul = 0;
int contadorAmarelo = 0;

void setup(){
	//Inicializa o Monitor Serial do Arduino IDE
	Serial.begin(9600);
	//Inicializa os servo motores
	inicializaServos();

	//Inicializa o estado de cada pino usado
	inicializaPinos();

	//Inicializa o LCD, ligando também o backlight.
	inicializaLCD();
}

void loop(){
	//Captura os valores RGB lidos neste instante
	leituraValoresRGB();

	//Mostra valores RGB no serial monitor
	exibirValoresRGBSerial();

	//Define a cor com base no valores RGB lidos
	defineCor();

	//Realiza a apresentação das informações no LCD
	escreveLCD();

	//Aciona os servos de acordo com a cor reconhecida
	movimentaMotores();
}

//Faz a inicialização definindo o estado de cada um dos pinos
//que estão sendo utilizados no Arduino.
void inicializaPinos(){
	pinMode(IN1, OUTPUT);
	pinMode(IN2, OUTPUT);
	pinMode(s0, OUTPUT);
	pinMode(s1, OUTPUT);
	pinMode(s2, OUTPUT);
	pinMode(s3, OUTPUT);
	pinMode(out, INPUT);

	digitalWrite(s0, HIGH);
	digitalWrite(s1, LOW);
}

//Inicializa o LCD ligando a luz de fundo para melhor visualização
//dos caracteres.
void inicializaLCD(){
	lcd.init();		 // Inicializando o LCD
	lcd.backlight(); // Ligando o BackLight do LCD
}

//Inicializa os servo motores nas posições iniciais que eles
//precisam estar para o correto funcionamento do sistema.
void inicializaServos(){
	servoCentro.attach(SERVO_CENTRO);
	servoCentro.write(90);
	servoEsquerda.attach(SERVO_ESQUERDA);
	servoEsquerda.write(90);
	servoDireita.attach(SERVO_DIREITA);
	servoDireita.write(90);
}

//Exibe os valores de cada componente RGB no Monitor Serial do Arduino.
void exibeValoresRGBSerial(){
	Serial.print("Vermelho :");
	Serial.print(red, DEC);
	Serial.print(" Verde : ");
	Serial.print(green, DEC);
	Serial.print(" Azul : ");
	Serial.print(blue, DEC);
	Serial.println();
}

//Apresenta a cor que está sendo identificada pelo sensor e o seu referido
//valor do contador ou então indica que nenhuma cor está sendo lida no LCD
//e também indica no Monitor Serial do Arduino.
void escreveLCD(){
	Serial.println(strCor);
	lcd.clear();
	lcd.print(strCor);
	if (strCor != "Nenhuma cor"){
		lcd.setCursor(0, 1); // Move o cursor do display para a segunda linha.
		lcd.print("Esferas: ");
		switch (strCor){
		case "Vermelho": //VERMELHO
			lcd.print(contadorVermelho);
			break;
		case "Azul": //AZUL
			lcd.print(contadorAzul);
			break;
		case "Amarelo": //AMARELO
			lcd.print(contadorAmarelo);
			break;
		}
	}
	delay(1000);
}

//Função que realiza a leitura da cor lida no instante atual
//e retorna o valor dos parametros red, green e blue.
void leituraValoresRGB(){
	digitalWrite(s2, LOW);
	digitalWrite(s3, LOW);

	red = pulseIn(out, digitalRead(out) == HIGH ? LOW : HIGH);
	digitalWrite(s3, HIGH);

	blue = pulseIn(out, digitalRead(out) == HIGH ? LOW : HIGH);
	digitalWrite(s2, HIGH);

	green = pulseIn(out, digitalRead(out) == HIGH ? LOW : HIGH);
}

//Define precisamente a cor da esfera com base nos valores RGB lidos.
void defineCor(){
	if (red > 250 && blue > 250 && green > 250){ //NENHUMA COR
		strCor = "Nenhuma cor";
	}
	else if (red < green && red < blue && green > blue){ //VERMELHO
		strCor = "Vermelho";
		contadorVermelho += 1;
	}
	else if (red > green && red > blue && green > blue){ //AZUL
		strCor = "Azul";
		contadorAzul += 1;
	}
	else if (red < green && red < blue && blue > green){ //AMARELO
		strCor = "Amarelo";
		contadorAmarelo += 1;
	}
}

//Efetua o movimento da posição do eixo do Servo passado como parâmetro
//de acordo com a variável valor passado como parâmetro.
void moverServo(Servo servo, int valor){
	servo.write(valor);
	delay(15);
}

//Realiza o movimento periódico do motor que fica no compartimento rotatório.
void movimentaMotorRotatoria(){
	//Gira o Motor A no sentido anti-horario
	for (int i = 0; i < 8; i++){
		digitalWrite(IN1, LOW);
		digitalWrite(IN2, HIGH);
		delay(10);
		//Pára o motor A
		digitalWrite(IN1, HIGH);
		digitalWrite(IN2, HIGH);
		delay(100);
	}
}

//Realiza os movimentos dos motores necessários para que a esfera de cor
//vermelha seja direcionada para o recipiente correto.
void movimentaVermelho(){
	for (posServoEsquerda = 90; posServoEsquerda < 140; posServoEsquerda++){
		moverServo(servoEsquerda, posServoEsquerda);
	}
	for (posServoDireita = 90; posServoDireita < 120; posServoDireita++){
		moverServo(servoDireita, posServoDireita);
	}
	for (posServoCentro = 90; posServoCentro > 0; posServoCentro--){
		moverServo(servoCentro, posServoCentro);
	}
	delay(5000);
	for (posServoCentro = 0; posServoCentro < 90; posServoCentro++){
		moverServo(servoCentro, posServoCentro);
	}
	for (posServoEsquerda = 120; posServoEsquerda > 90; posServoEsquerda--){
		moverServo(servoEsquerda, posServoEsquerda);
	}
	for (posServoDireita = 140; posServoDireita > 90; posServoDireita--){
		moverServo(servoDireita, posServoDireita);
	}
}

//Realiza os movimentos dos motores necessários para que a esfera de cor
//azul seja direcionada para o recipiente correto.
void movimentaAzul(){
	for (posServoEsquerda = 90; posServoEsquerda > 50; posServoEsquerda--){
		moverServo(servoEsquerda, posServoEsquerda);
	}
	for (posServoDireita = 90; posServoDireita > 40; posServoDireita--){
		moverServo(servoDireita, posServoDireita);
	}
	for (posServoCentro = 90; posServoCentro > 0; posServoCentro--){
		moverServo(servoCentro, posServoCentro);
	}

	delay(5000);

	for (posServoCentro = 0; posServoCentro < 90; posServoCentro++){
		moverServo(servoCentro, posServoCentro);
	}
	for (posServoEsquerda = 50; posServoEsquerda < 90; posServoEsquerda++){
		moverServo(servoEsquerda, posServoEsquerda);
	}
	for (posServoDireita = 40; posServoDireita < 90; posServoDireita++){
		moverServo(servoDireita, posServoDireita);
	}
}

//Realiza os movimentos dos motores necessários para que a esfera de cor
//amarela seja direcionada para o recipiente correto. Neste caso precisamos
//apenas liberar a porta central.
void movimentaAmarelo(){
	for (posServoCentro = 90; posServoCentro > 0; posServoCentro--){
		moverServo(servoCentro, posServoCentro);
	}
	delay(5000);
	for (posServoCentro = 0; posServoCentro < 90; posServoCentro++){
		moverServo(servoCentro, posServoCentro);
	}
}

//Realiza o movimento dos motores de acordo com a cor que foi reconhecida.
void movimentaMotores(){
	switch (strCor){
	case "Nenhuma cor":
		movimentaMotorRotatoria();
		break;
	case "Vermelho":
		movimentaVermelho();
		break;
	case "Azul":
		movimentaAzul();
		break;
	case "Amarelo":
		movimentaAmarelo();
		break;
	}
	delay(5000);
}