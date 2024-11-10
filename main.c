#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
int main()
{
    int *array = NULL,*copyarray=NULL; //gereli parametreler array dizi, copyarray ise islemlerde kullanliacak orjinal olmayan dizi
    int size,l,i,j,h; // size dizinin boyutu ,l,i,j,h for donguleri icin parametre
    clock_t start, end; // zaman hesaplaması icin baslama ve bitis degerlerini burada tutuyorum
    double elapsed; // start-end yapildiginde islem kac saniyede tamamlandı burada gosterecek
    FILE *file = fopen("output.txt", "w"); // output.txt dosyasinda n-k ve sure degerlerini tutacagim

    srand(time(NULL));  //zaman hesabı icin
    for(l=0;l<10;l++){ //dis dongu her n ve k degeri icin tek kod calismasinda 10 defa calistirmak icin yani 10 farkli diziyi k-mergesorta sokmak icin bu for var
    printf("---------------------------------------------\n");
    printf("Array : %d \n",l+1);                                    //konsola yazdirma
    printf("---------------------------------------------\n");
    fprintf(file, "---------------------------------------------\n");
    fprintf(file, "Array Set %d\n", l + 1);                                 //dosyaya yazdirma
    fprintf(file, "---------------------------------------------\n");
        for ( i = 0; i < 6; i++) {  // Bu örnekte döngü 5 kez çalýþacak.       // n degerleri icin olan dongu
        size = pow(10, i) * 100;                    // her bir dongude n 10 ile carpiliyor burada aslin mesela i=0 10^0*100 = 100 i=1 10^1*100 = 1000 ...

        array = (int *) realloc(array, size * sizeof(int));         // orijinal dizi
        copyarray = (int *) realloc(copyarray, size * sizeof(int)); // islemlerin yapilcagi kopya dizi dizi
        if (array == NULL) {
            printf("Memory allocation failed.\n");
            fprintf(file, "Memory allocation failed.\n");
            return 1;
        }

        generate_unique_random_array(array, size);     // orijinal diziyi rastgele degerlerle dolduruyoruz

        printf("Array of size %d: \n", size);   //terminale yazdirma islemi

        fprintf(file, "\n", size);
        fprintf(file, "N = %d için sonuçlar:\n", size);     //dosyaya yazdirma islemi
        fprintf(file, "\n", size);

        for(j=2;j<=10;j++){
            for(h=0;h<size;h++){
                copyarray[h]=array[h];  //kopya arrayi her k degeri icinorijinal diziye esitliyorum ki ayni dizi icin farklı k degerleri ile deger alayim
            }
            start = clock();        // zamani baslatiyyorum

            mergeSort(copyarray, 0, size - 1, j);   //k-way merge sort islemi basliyor

            end = clock();          // zamani durduruyorum
            /*          bu kisim sadece arraylerin icini dogru siralanip siralanmadiklerini gormek icin test yaptim isterseniz sizde bakabilirsiniz
             for(h=0;h<size;h++){
                printf("%d ",array[h]);
            }
                printf("\n");
            for(h=0;h<size;h++){
                    printf("%d ",copyarray[h]);
            }
            printf("\n");
            sleep(1);
            */
            elapsed = ((double)(end - start)) / CLOCKS_PER_SEC;     //toplam gecen sure hesaplaniyor
            printf("N = %d K= %d icin kullanilan zaman : %lf\n",size,j,elapsed);    //terminale total sure cikti veriliyoor
            fprintf(file, "N = %d, K = %d, Süre: %lf saniye\n", size, j, elapsed);  // outputa total kullanilan sure cikti veriliyor

        }

        printf("\n");
    }

    }


    return 0;
}

/*
@brief random istenilen boyuttaki diziyi olusturmak icin kullanildi once dizi bastan sona dolduruluyor sonra ise karistiriliyor

@param *arr onceden dinamik olarak olusturulan ve buraya yollanan olusturulacak dizi
@param n olusturulacak dizinin boyutu

*/
void generate_unique_random_array(int *arr, int n) {
    int i,j,temp;   //donguler icin i ve j temp ise karistirma islemi icin
    for ( i = 0; i < n; i++) {
        arr[i] = i + 1; //dizi bastan sona sirali bir sekilde 1,2,3,4,5.....,n(size) degerine kadar dolduruluyor
    }
    for ( i = 0; i < n; i++) {  // burada ise dizide rastgele bir sekilde karistirma islemi yapiyoruz ve dizi rastgele karilmis oluyor
         j = rand() % n;        // random index
         temp = arr[i];          // temp=i
         arr[i] = arr[j];       // i ve j indxleri yer degistirme islemi
         arr[j] = temp;         // i ve j indxleri yer degistirme islemi
    }
}

/*
@brief k-way mergesort algoritmasi yani bolunme islemleri recursive olarak burada olacak

@param *arr islemlerin yapilacagi dizi
@param left dizinin sol indexi siniri
@param rigth dizinini sag indexi yani siniri
@param k ise k way sortta ki k degeri yani 4e bole bole gidiyorsak 4-way merge sort ise k=4 olacak

*/

void mergeSort(int *arr, int left, int right, int k) {
    int i,key,j,part_size,  mid[k + 1]; // i,j,key gecici degiskenler / part_size, mid(k+1) bolme ve sinir islemleri icin degiskenler
    if (right - left < k) {// eger bolum boyutu k dan kucukse siralama yap

        for ( i = left + 1; i <= right; i++) {
                // Insertion sort ile siralama yap: arr[i] ogesini uygun yere yerlestir
             key = arr[i];
             j = i - 1;
            while (j >= left && arr[j] > key) {
                // eger arr[j] key'den buyukse, arr[j]'yi bir saga kaydır
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;  // key ogesini dogru yere yerleştir

        }
        return; // kuuck segment siralandi fonksiyonu bitir
    }

    part_size = (right - left + 1) / k;   // bolum boyutunu hesapla: (dizinin uzunlugu) / k
    mid[0] = left; // ilk bolumun baslangic siniri sol sinir olarak atandi
    for ( i = 1; i < k; i++) {
        mid[i] = mid[i - 1] + part_size; // mid[] dizisini her bir bölümün baslangic indeksini tutacak sekilde doldur
    }
    mid[k] = right + 1;     // Son bolumu direkt rigth+1 yaparak atadik


    for ( i = 0; i < k; i++) {
        mergeSort(arr, mid[i], mid[i + 1] - 1, k);   // Her bir parcayi siralamak icin recursive olarak mergeSort cagir
    }

    merge_i(arr, left, mid, right, k);  //birlestirme icin ise recursiveler bitince merge et
}

/*
@brief bu fonksiyon k-way merge sort algortimasinin bir parcasidir ve sirali parcalari birlestirir

@param *arr islemlerin yapilacagi dizi
@param left dizinin sol indexi siniri
@param rigth dizinini sag indexi yani siniri
@param mid[] dizisi k esit parcaya bolunen dizinin sinirlarini tutar yani her bir mid[i] degeri, dizinin i-inci parcasini baslangic indeksini belirtir.
@param k ise k way sortta ki k degeri yani 4e bole bole gidiyorsak 4-way merge sort ise k=4 olacak

*/

void merge_i(int *arr, int left, int mid[], int right, int k) {
    int *temp = (int *)malloc((right - left + 1) * sizeof(int)); // birlestirilmis diziyi tutmak icin gecici dizi
    int idx[k]; // Her parca icin gecici indeks dizisi
    int min_idx=0,min_val,i,tempIdx;    // minimum olan indeks ve ona ait minimum deger min val, tempIdx ise temp gorevi goruyor
    for ( i = 0; i < k; i++) {
        idx[i] = mid[i];            // esitleme yapiliyor idx gecici dizisine midde ki sinirlar aktariliyor
    }

     tempIdx = 0;       //temp = 0
    while (min_idx != -1) {//control degiskeni minidx -1 olursa biter dizi
         min_val = 10000000;        // 10000000 kucuk degerler olacak ve ilk default deger bu olsunki saglikli bir sekilde baslayalim
         min_idx = -1;              // control saglaniyor assagida degismezse dizi biter yani siralanir
        for ( i = 0; i < k; i++) {
            if (idx[i] < mid[i + 1] && arr[idx[i]] < min_val) {
                min_val = arr[idx[i]];  // en kucuk degeri bul
                min_idx = i;                // bu min degerin hangi parcadan geldigini kaydet
            }
        }
        if(min_idx != -1 )  //minidx -1 degilse buraya gir
        {
           temp[tempIdx++] = arr[idx[min_idx]]; // en kucuk degeri gecici dizime ekledim
            idx[min_idx]++;         // bu parcada bir sonraki elemana gec
        }

    }

    for ( i = 0; i < tempIdx; i++) { // gecici diziyi orijinal diziye kopyala
        arr[left + i] = temp[i];
    }

    free(temp); // temp dizisini tutan alani serbest birak
}
