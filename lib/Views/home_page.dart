import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late String ad, id, kategori;
  late int sayfasayisi;

  @override
  Widget build(BuildContext context) {
    idAl(idDegeri) {
      this.id = idDegeri;
    }

    isimAl(adDegeri) {
      this.ad = adDegeri;
    }

    kategoriyAl(kategoriDegeri) {
      this.kategori = kategoriDegeri;
    }

    sayfasayisiAl(sayfasayisiDegeri) {
      this.sayfasayisi = int.parse(sayfasayisiDegeri);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Crud uygulaması"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String idDegeri) {
                  idAl(idDegeri);
                },
                decoration: const InputDecoration(labelText: "Kitap ID", focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String adDegeri) {
                  isimAl(adDegeri);
                },
                decoration: const InputDecoration(labelText: "Kitap Adı", focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String kategoriDegeri) {
                  kategoriyAl(kategoriDegeri);
                },
                decoration: const InputDecoration(labelText: "Kitap Kategorisi", focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String sayfasayisiDegeri) {
                  sayfasayisiAl(sayfasayisiDegeri);
                },
                decoration: const InputDecoration(labelText: "Kitap sayfa sayısı", focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      veriEkle();
                    },
                    child: Text("Ekle"),
                    style: ElevatedButton.styleFrom(primary: Colors.green, onPrimary: Colors.white, shadowColor: Colors.redAccent, elevation: 5),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     veriOku();
                  //   },
                  //   child: Text("Oku"),
                  //   style: ElevatedButton.styleFrom(primary: Colors.blue, onPrimary: Colors.white, shadowColor: Colors.redAccent, elevation: 5),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      veriGuncelle();
                    },
                    child: Text("Güncelle"),
                    style: ElevatedButton.styleFrom(primary: Colors.amber, onPrimary: Colors.white, shadowColor: Colors.redAccent, elevation: 5),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriSil();
                    },
                    child: Text("Sil"),
                    style: ElevatedButton.styleFrom(primary: Colors.red, onPrimary: Colors.white, shadowColor: Colors.redAccent, elevation: 5),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('kitaplik').snapshots(),
                builder: (context, alinanVeri) {
                  if (alinanVeri.hasError) return const Text("Akatarım başarısız");
                  if (alinanVeri.data == null) return const CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.red),);
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: alinanVeri.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot satirVerisi = alinanVeri.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20,10,20,10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(satirVerisi['kitapId'])), 
                              Expanded(
                                flex: 5,
                                child: Text(satirVerisi['kitapAd'])),
                              Expanded(
                                flex: 3,
                                child: Text(satirVerisi['kitapKategori'])),
                              Expanded(
                                flex: 1,
                                child: Text(satirVerisi['kitapSayfaSayisi']))
                              ],
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }

  void veriEkle() {
    DocumentReference veriYolu = FirebaseFirestore.instance.collection("kitaplik").doc(id);
    Map<String, dynamic> kitaplar = 
    {"kitapId": id,
     "kitapAd": ad, 
     "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfasayisi.toString()};
    veriYolu.set(kitaplar).whenComplete(() {
      Fluttertoast.showToast(msg: id + "ıd numarali kitap eklendi");
    });
  }

  void veriOku() {
    // DocumentReference veriOkumaYolu = FirebaseFirestore.instance.collection("kitaplik").doc(id);
    // veriOkumaYolu.get().then((alinanDeger) {
    //   Map<String, dynamic> alinanVeri = alinanDeger.data();
    //   String idTutucu = alinanVeri["kitapId"];
    //   String adTutucu = alinanVeri["kitapAd"];
    //   String kategoriTutucu = alinanVeri["kitapKategori"];
    //   String sayfaSayiciTutucu = alinanVeri["kitapSayfaSayisi"];
    // });
  }

  void veriGuncelle() {
    DocumentReference veriGuncellemeYolu = FirebaseFirestore.instance.collection("kitaplik").doc(id);

    Map<String, dynamic>  guncelleVeri = {
      "kitapId": id,
     "kitapAd": ad, 
     "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfasayisi.toString()
    };
    veriGuncellemeYolu.update(guncelleVeri).whenComplete(() {
      Fluttertoast.showToast(msg: id + " Id numarali kitap guncellendi");
    });
  }

  void veriSil() {
    DocumentReference veriSilmeYolu = FirebaseFirestore.instance.collection("kitaplik").doc(id);
    veriSilmeYolu.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id + "ıd numarali kitap silindi");
    });
  }
}
