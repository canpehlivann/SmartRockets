class Population { //pop sınıfı.
  Rocket[] rockets; //roket dizisi olarak referans
  int popsize; //pop boyutu.
  List<Rocket> matingpool; // eşleşme havuzu algoritması . Örneğin;
  // A B C D olarak elimizde 4 tane harf olsun.Bunları bir diziye koyalım.Her birinin de uygunluk oranı sırasıyla 4 3 2 1 olsun.
  //Dizideki her elemanın %25 seçilme şansı var.Ama herbirinin uygunluk oranı(fitness rate)farklı olduğundan
  //sağlıklı sonuçlar elde edemeyiz. Bu yüzden seçimleri eşleşme havuzundan yapacağız.Yukarıdaki duruma göre eşleşme havuzu
  // A A A A B B B C C D şeklinde olacak.Bu şekilde sağlıklı seçimler yapabileceğiz.

  Population() {
    popsize = 50; //pop boyutu.kaç tane roket olacağını söylüyor.
    rockets = new Rocket[popsize]; //belirlenen roket sayısı kadar roket oluşturuyoruz.
    matingpool = new ArrayList<Rocket>(); //Liste türünden bir havuz.

    for (int i = 0; i < popsize; i++) {
      rockets[i]  = new Rocket(); //0'dan popsize'a kadar oluşturduğumuz roketleri roket dizisine ekliyoruz.
    }
  }

  float evaluate() { //Değerlendirme fonksiyonu.Popülasyondaki her bir elemanın fitness oranını hesaplayarak buna göre
  //eşleşme havuzu oluşturuyoruz.
    float avgfit = 0; // ortalama fit.
    float maxfit = 0; // maksimum fit. Bunlar fitness oranını ve buna bağlı yapmak istediklerimiz konusunda 
    // manipülatif rol oynayacaklar.Bunları kullanarak kontroller yapacağız.
    for (Rocket rocket : rockets) { 
      rocket.calcFitness(); //her bir roketin fitness oranını hesaplayacağız.
      if (rocket.fitness > maxfit) { 
        maxfit = rocket.fitness; // eğer ilgili roketin fitness oranı maksimum orandan yüksek olursa yeni maksimum oran olur.Ancak bu ham değil.
        //ancak bu ilgili roketin fit.oranı ham.
      }
      avgfit += rocket.fitness; //diyelim yeni maks oran elde edemedik.Buna rağmen fitness oranının sabit kalmamasını istiyoruz.
      //iyileştirmek için her bir roketin fit.oranını ortalama fit'e ekliyoruz.Ancak ham bir şekilde normalize etmeden eklemek
      //çok farklı sonuçlar yaratır. Genetik bilginin çalışma şeklini bozabilir.Genetik bilgiyi farklı bir şeye dönüştürür.
    }
    avgfit /= rockets.length;  // fit.oranlarını roketlerin uzunluğuna bölerek normalize ediyoruz.Büyük sayıları 
    //küçük bir aralıkta ifade ediyoruz.

    for (Rocket rocket : rockets) {
      rocket.fitness /= maxfit; //roketlerin fitness oranı maxfit'e bölünür ve normalize edilir.
    }

    matingpool = new ArrayList<Rocket>(); //roketlerin türünden havuzu oluşturuyoruz.

    for (Rocket rocket : rockets) {
      float n = rocket.fitness * 100; // roketlerin fit.oranını 100 ile çarparak 
      for (int j = 0; j < n; j++) {//havuza ekliyoruz.
        matingpool.add(rocket);
      }
    }

    return avgfit; // ortalama fit oranını döndürüyoruz.
  }

  Rocket random(List<Rocket> list) {
    int r = (int)(Math.random() * (list.size())); //
    return list.get(r); 
  }

  void selection() {                                                    //seçilim fonksiyonu.
    Rocket[] newRockets = new Rocket[popsize];                           //Oluşan yeni roketlerin sayısı eski roketlerin sayısı kadar olacak.
    for (int i = 0; i < rockets.length; i++) {                          //Her bir rokete seleksiyonu uygulayacağız.Eşleşme havuzundan
      DNA parentA = random(matingpool).dna;                             //yaparak onların DNA'larından bir çocuk oluşturacağız.Crossover fonk'u çağırdık.
      DNA parentB = random(matingpool).dna;
      DNA child = parentA.crossover(parentB);                           
      child.mutation();                                                 //Çocuğu mutasyona uğrattık.
      newRockets[i] = new Rocket(child);                                //Oluşan çocuğu yeni roketler dizisine ekledik.
    }

    rockets = newRockets;                                                    //En sonunda da yeni roketler dizisinin kendisini eski dizinin yerine geçirdik.
  }

  void run() {
    for (Rocket rocket : rockets) {                                       //Roketler,simülasyon boyunca durmamalı.Sürekli
    //hareket halinde olmaları için update fonksiyonunu çağırdık.Ardından ekranda ilerlemiş halinin görülmesi için(bu da durmamalı)show'u.Bu da 
    //genel olarak onları çağırdığımız run fonksiyonu.
      rocket.update();
      rocket.show();
    }
  }
}
