//Bu class main class.Burada setup ve draw olarak iki fonksiyonumuz var.Setup objeleri initialize ederken drawda sürekli bir fonk olup 
//ekrana çiziyor.Sürekli hesaplama gerektiren yerlerde de draw kullanılır.
/****REFERANSLAR,TANIMLAMALAR,DEKLERASYONLAR*****/
Rocket rocket;   //rocket referansı
Population population; //popülasyon referansı
PVector target; //ulaşılması gereken hedef vektör
float maxforce = 0.2;  //maksimum kuvvet = 0.2;

int lsp; //çevrim
float stat; //ilk çevrim sonrası durum

int generation = 0; //jenerasyon 0'dan başlıyor.

float barrierx; //engelin x eksenindeki pos.
float barriery; //engelin y eksenindeki pos.
float barrierw; //engelin genişliği
float barrierh; //engelin yüksekliği 

void setup() {
  size(1024, 768); //Ekranın boyutu
  population = new Population(); //popülasyon objesi oluşturduk.
  rocket = new Rocket(); // roket objesi oluşturduk.
  target = new PVector(width / 2, 50); //hedef vektörün initialize edilmesi.
  lsp = 0; //çevrim başta sıfır(sayaç = 0)

//ENGELİN X-Y KONUMU VE EKRANDAKİ GENİŞLİK VE YÜKSEKLİĞİ
  barrierw = width / 8; 
  barrierh = 10;
  barrierx = (width - barrierw) / 2;
  barriery = (height - barrierh) / 2;
}

//Arkaplan rengi mavi olacak şekilde sürekli çizilir.
void draw() { //Sürekli bir fonk.
  //clear fonksiyonu her bir frame(kare) sonrası ekranı hemen siler ve tekrar çizer.Sürekli sürekli
  //çizdirmek yerine silip tekrar çizmek belleği rahatlatır.
  clear();
  background(23,85,121); //mavinin bir tonu

  // hedefi çizer.Burası tamamen çizimle ve renklerle boyamayla alakalı.
  stroke(255); 
  fill(128);
  ellipse(target.x, target.y, 20, 20);
  fill(100);
  noStroke();
  strokeWeight(2);
  ellipse(target.x+2, target.y-2, 10, 10);

  // Verilen parametrelerin ifade ettiği engel çizilir.line çizgi çizer.rect dikdörtgen.
  fill(255, 0, 0);
  stroke(128);
  rectMode(CORNER);
  rect(barrierx, barriery, barrierw, barrierh);
  strokeWeight(1);
  stroke(55, 0, 0);


  population.run(); //çizim tamamlandıktan sonra pop çalıştırılır.

  lsp++; //çevrim artırılır.400'e yani cycle değerine ulaşınca pop değerlendirilir ve seçim yapılır.(crossover-mutation) sonra 
  //çevrim sıfırlanır ve yeni jenerasyon hareket eder.
  if (lsp >= cycle) {
    stat = population.evaluate();
    population.selection();
    lsp = 0;
    generation++;
  }
//BU KISIMDA EKRANDAKİ BİLGİLENDİRME YAZILARI İÇİN.
  textSize(18); //yazı boyutu 18.
  noStroke(); //kenarlık yok.
  fill(255, 128, 0); // yazı rengi
  text("Gen: " + generation, 20, 20); //gen yazısı ve ekrandaki konumu
  text("lsp: " + lsp, 20, 40); //lsp yazısı ve konumu
}
