import java.util.*;

int cycle = 350; //350 çevrim sonrası yeni jenerasyona geçecek.

class DNA {            //DNA objesi oluşturuyoruz. DNA sonraki nesillere uygunluğa göre en iyi
//genetik özelliği aktaracak. (FITNESS FUNCTION-UYGUNLUK FONKSİYONU)
  PVector[] genes; //DNA'nın taşıdığı genetik bilgi vektör türünden olacak.Çünkü roketlerin hedefe
  //ulaşıp ulaşmadığını görebilmek için roketlerle hedef arasındaki uzaklığa ihtiyacımız var.
  DNA() { //DNA objesi ve içeriği
    genes = new PVector[cycle]; //çevrim kadar  PVector'ü array olarak ifade etmek için PVector[] kullanılır.
    //Her bir roketin birbirinden farklı uzaklıklara gitmesini içindeki genetik bilginin aynı olmamasıyla
    //sağlıyoruz.Bunun için de random vektörler yaratıyoruz.

    for (int i = 0; i < cycle; i++) { //0'dan 350'ye kadar rastgele vektörler oluşturuyoruz.Bunlardan bazıları yaptığımız
    //işlemlere göre hedefi tutturabilir.
      PVector gene = PVector.random2D(); //random2d fonksiyonu rastgele bir yönde bir birim vektör döndürür.
      gene.setMag(maxforce);        //Maks.kuvvet vektörünü,farklı uzaklıklarda yaratılan vektörlere uyguluyoruz.
      //Hepsine aynı kuvvet.Bu da farklı olabilir.Ama bu hedefi tutturma olasılığını düşüredebilir.
      genes[i] = gene; //her bir oluşan random vektörü diziye ekliyoruz.
      
    }
  }

  DNA(PVector[] genes_) {
    genes = Arrays.copyOf(genes_, genes_.length);  //yeni genlerin Constructor'ı.yeni genlerin uzunluğu kadar bir dizi oluşturulur.
    //Yeni içerik buralara kopyalanır.Buralarda eski içerik varsa yenisiyle değiştirilir.
  }

  DNA crossover(DNA partner) {                      //Crossover fonksiyonu.Crossover,iki üyenin(anne baba) genlerindeki çaprazlama sonucu rastgele
  //gen dizilimine sahip bir çocuk oluşturur. Örnek unicorm ve popjorn diye iki kelimemiz olsun.Bunlar anne ve baba.Her ikisinin harflerini de dizinin
  //elemanları olarak düşünelim.unicorm'un uni'sini ve popjorn'un jorn'unu alalım.Buna crossover deniyor.unijorn adında bir kelimemiz oldu.Bu da çocuk.
    PVector[] newgenes = new PVector[genes.length]; //Crossover'da yeni genler oluşacak.newgenes ile ifade edildi.İki vektörden
    //bir çocuk vektör oluşacak.Vektörlerin içindeki veriler dahilinde(uzunluk,yön) yeni bir çocuk oluşacak.
    //Tür olarak genetik bilgisi vektördü o yüzden vektör.
    int mid = (int) random(genes.length); //genlerin bölüneceği nokta.Bu da rastgele seçilecek.Çünkü sürekli aynı noktadan kesildiğini düşünürsek
    //unicorm ve popjorn için sürekli unijorn adında bir çocuk doğacak.
    for (int i = 0; i < genes.length; i++) { //0'dan genlerin uzunluğuna kadar.Burada genler vektörel bir ifade.
      if (i > mid) { 
        newgenes[i] = genes[i]; // Eğer bölünme noktası i'den küçük olursa ilgili gen yeni gen olacak.
      } else {
        newgenes[i] = partner.genes[i]; //Değilse atasının genine sahip olacak.
      }
    }
    return new DNA(newgenes); //yeni DNA'yı bellekte tutuyoruz. 
  }

  void mutation() {  //MUTASYON
    for (int i = 0; i < genes.length; i++) {
      if (random(i) < 0.01) { //Mutasyon oranı 0.01 belirlenmiş.Rastgele seçilen bir gen(vektör) verilen orandan düşükse rastgele bir yönde bir 
      //birim vektör oluşturulup bu vektörün kuvveti belirlenir.Ardından bu gen genler(genes)dizisine eklenir.
        PVector gene = PVector.random2D(); //Yine yukarıda DNA'nın içeriğini ve nasıl şeyler yapacağını belirlerken yaptıklarımızı yapıyoruz.
        gene.setMag(maxforce);        
        genes[i] = gene;
      }
    }
  }
}
