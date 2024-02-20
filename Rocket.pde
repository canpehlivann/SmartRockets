final float maxvelocity = 4; //roketin maksimum hızı.

class Rocket {
  PVector pos; //Pozisyon vektörü.Bir roketin pozisyonu.Hareket vektörü.
  PVector vel; //Hız vektörü.
  PVector acc; //İvme vektörü
  DNA dna; //DNA referansı
  float fitness = 0; // fitness
  boolean hitTarget = false; //Hedefe vurup vurmadığını kontrol eden flag.
  boolean crashed = false; //Engele çarpıp çarpmadığını kontrol eden flag.

  Rocket() {
    this(new DNA()); //roketin DNA'sı.Her bir roket için yeni bir DNA.
  }

  Rocket(DNA dna_) { //Her bir roketin özellikleri
    pos = new PVector(width / 2, height - 20); //Hareket vektörü ekran genişliğinin yarısı(yani merkez) ile ekranın en altından 20 piksel yukarısında oluşuyor.
    vel = new PVector(); //Hız vektörünü initialize ettik.
    acc = new PVector(0, -0.01); //İvme çok küçük ters yönde ufacık bir etki ediyor.
    dna = dna_; 
    fitness = 0; // fitness en başta 0.
    hitTarget = false; //hedefi vurmamış.
    crashed = false; //engellere çarpmamış.
  }

  void applyForce(PVector force) {
    acc.add(force); //Kuvvet uygulama fonksiyonu.Kuvvet vektörünü ivmeye ekler.İvmenin etkisi artar.
  }

  void calcFitness() {             //FITNESS HESAPLAMA
    float d = distanceToTarget(); //Buradaki uygunluk, roketlerin hedefe ne kadar yaklaşıp yaklaşmadığıdır.Yani hedefle roket arasındak uzaklıktır.
    //Hesaplama buna göre yapılır.
    fitness = map(d, 0, width, width, 0);  //eşleme fonksiyonu.İki değeri alır ve bu değerleri bir aralığa yerleştirir.Burada
    // bir aralığa yerleştirilecek olan değer d hedefe olan uzaklık.Ekranın sol köşesi(0) ile ekran genişliğinin(sağ köşe-width)arasından ekran genişliği ve sol köşe arasındaki
    //bir aralığa yerleştirilir.Yani uzaklık,ekrandaki uzaklığa çevrildi.
    if (hitTarget) {
      fitness *= 10; //Eğer hedefi vurursa fitness değerini 10 ile çarp.
    } else if (crashed) {
      fitness /= 10; //Eğer engele çarptıysa 10'a böl.
    }
  }

  float distanceToTarget() {
    return dist(pos.x, pos.y, target.x, target.y);                   //Bu fonksiyon roketlerin hedefe olan uzaklığını hesaplar.dist fonksiyonu bir builtin fonksiyondur.
    //iki vektör arası uzaklık.
  } 

  void update() {
    float d = distanceToTarget();
    if (d < 10) {
      hitTarget = true;
      pos = target.copy();
    }                                    //Bu fonk, roketlerin hedefe olan uzaklığını roketler sürekli hareket halinde oldukları için
    //günceller.Güncelleme süreklidir.Eğer uzaklık 10'dan küçükse hedef vurulmuştur ve pozisyon,hedefin pozisyonunun kopyasıdır.

    if (pos.x > barrierx && pos.x < (barrierx + barrierw) && pos.y > barriery && pos.y < (barriery + barrierh)) { //x-y lokasyonlar(eksenlerdeki konumları) ve w-h ler genişlik ve 
    //yükseklik.
      crashed = true; //Eğer roketin x eksenindeki pozisyonu,engelin x eksenindeki pozisyonundan ve aynı zamanda engelin x eksenindeki pozisyonu ile genişliğinin toplamından
      //küçükse;eğer roketin y eksenindeki pozisyonu,engelin y eksenindeki pozisyonundan ve aynı zamanda engelin y eksenindeki pozisyonu ile yüksekliğinin toplamından
      //küçükse,roketin yarısından azı veya daha fazlası engele çarpmıştır.Engele çarpma flag'ini true olarak değiştir. Kağıt kalem olmadan bu kısmı gösterebilmem zor hocam :)
      //Bu kısım,çarpışmaları hesaplama vs. biraz zor :) 
      
    }
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      crashed = true; //Ayrıca roketlerin x eksenindeki pozisyonu veya y eksenindeki pozisyonu,ekranın genişliğinden veya yüksekliğinden
      //büyük olduğu zaman cisim ekran dışına çıkar.Ya da küçük olursa.Bunu engellemek için çarptığı an flag'i true yaparız.Flag true olursa da hızı sıfırlarız.Hareketsiz kalır.
    }

    applyForce(dna.genes[lsp]); //çevrim bitene dek (sayaç) genlere kuvvet uygulama fonksiyonu uygulanarak hareket etmesi sağlanacak.

    if (!hitTarget && !crashed) { //Eğer hedefi vurmadı ve engele çarpmadıysa
      vel.add(acc);               //hareket devam edecek.İvme hıza eklenir.Hız pozisyon vektörüne eklenir.Ardından ivme 0'lanır çünkü sürekli 
      //sabit ivmeyle hareket edecekler.Hızı da limit ile maks.hıza limitledik.
      pos.add(vel);
      acc.mult(0);
      vel.limit(maxvelocity);
    }
  }

  void show() {  //Çizimleri oluşturduğumuz fonksiyon.Her şey,her çizimin ve hesaplamaların ilgili rokete ait olması
  //için push ve pop arasına yazılır.
    pushMatrix();
    noStroke();
    if (hitTarget) { //Eğer hedefi vurursa roket,yeşil olacak.
      fill(50, 205, 50);
    } else if (this.crashed) { //Eğer engele çarparsa,soluk bir gri.
      fill(128, 128, 128);
    } else {
      fill(255, 150); //İki durumda yaşanmadıysa standart renginde.
    }

    translate(pos.x, pos.y); //Translate = yer değiştirme. Çevrim.X ve Y pozisyonu sürekli yer değiştireceği için
    //bu hesaplamayı yapıyoruz.
    rotate(vel.heading()); //Döndürme.

    // roketin gövdesini çiz.Dikdörtgen şeklinde.
    rectMode(CENTER); 
    rect(0, 0, 25, 5);

    // roketin başlığını çiz.Elips şeklinde.
    fill(165, 42, 42);
    ellipse(12, 0, 10, 5);

    if (!hitTarget && !crashed) { //Engele çarpmadıkça ve hedefi tutturamadıkça roketin ateşini çiz.
    //üçgen şeklinde olacak.beginShape() ile çizime başlanır.endShape() ile bitirilir.Aradaki vertexler noktasal
    //çizimlerdir.noktalar bir araya gelir ve bir çizgi oluşur.3 çizgi üçgen oluşturur.
      fill(255, 140 + random(0, 115), random(0, 128));  //ateşin içini fill ile istenilen renklerle doldurduk.
      //G ve B renk değerlerine random bir değerin eklenmesi şeklinde oluşan bir hesaplama yaptık.Çünkü sürekli farklı
      //değerleri ilgili sayılara eklersek farklı renkler elde edeceğiz ve bu çizim işlemi sürekli ve çok hızlı bir şekilde
      //olacağı için ekranda roketin arkası alev alıyormuş gibi görünecek.
      beginShape();
      //üçgenin noktalarının köşe ve kenarları
      vertex(-14, -3);
      vertex(-35, 0);
      vertex(-14, 3);
      endShape();
    }

    popMatrix(); 
  }
}
