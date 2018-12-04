// parametres
const int nb_Drum = 5;
const int delay_Tram = 20;

struct struct_drum {
	String id;
	int  pin;
	int  mesure;
	int  seuil;
	int  cpt_mesure;
	int  nb_mesure;
	int  max_mesure;
};
struct_drum str_Drum1 = {"D1", A0, 0, 0, 0, 0, 0};
struct_drum str_Drum2 = {"D2", A1, 0, 0, 0, 0, 0};
struct_drum str_Drum3 = {"D3", A2, 0, 0, 0, 0, 0};
struct_drum str_Drum4 = {"D4", A3, 0, 0, 0, 0, 0};
struct_drum str_Drum5 = {"D5", A4, 0, 0, 0, 0, 0};

struct_drum* ptr_Drums[nb_Drum] = {&str_Drum1, &str_Drum2, &str_Drum3, &str_Drum4, &str_Drum5};

unsigned long old_time;

void setup() {
	Serial.begin(115200);
	Serial.println("--- Start Drums ---");
	old_time = millis();
}

void loop() {

	for(int i = 0; i < nb_Drum; i++)
	{
		Evaluation_Drum(ptr_Drums[i]);
	}

	if ((millis() - old_time) > delay_Tram)
	{
		old_time = millis();
		String strTram = Affiche_Drum(ptr_Drums[0]); 
		for(int i = 1; i < nb_Drum; i++)
		{
			strTram += "," + Affiche_Drum(ptr_Drums[i]);
		}
		Serial.println("[" + strTram + "]");
	}
}

void Evaluation_Drum(struct_drum* ptr_temp)
{
	int value = analogRead(ptr_temp->pin);

	ptr_temp->mesure     = value;
	ptr_temp->cpt_mesure = ptr_temp->cpt_mesure + value;
	ptr_temp->nb_mesure  = ptr_temp->nb_mesure  + 1;

	if (ptr_temp->max_mesure < value)
		ptr_temp->max_mesure = value;
}

String Affiche_Drum(struct_drum* ptr_temp)
{
	//int mesure = (ptr_temp->nb_mesure > 0) ? ptr_temp->cpt_mesure / ptr_temp->nb_mesure : 0;
	//return (mesure > ptr_temp->seuil) ? String(ptr_temp->id + ":" + mesure) : "";
	
	int mesure = ptr_temp->max_mesure;

	ptr_temp->cpt_mesure = 0;
	ptr_temp->nb_mesure  = 0;
	ptr_temp->max_mesure = 0;

	return String(ptr_temp->id + ":" + mesure);
}

void RazCpt(struct_drum* ptr_temp)
{
	ptr_temp->cpt_mesure = 0;
	ptr_temp->nb_mesure  = 0;
	ptr_temp->max_mesure = 0;
}
