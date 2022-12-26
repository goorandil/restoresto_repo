import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          'greeting': '안녕하세요',
        },
        'ja_JP': {
          'greeting': 'こんにちは',
        },
        'en_US': {
          // main
          'If not, leave it blank': 'If not, leave it blank',
          'Name': 'Name', 'Phone': 'Phone', 'Address': 'Address',
          'from gallery': 'from gallery',
          'from camera': 'from camera',
          'See all categories': 'See all categories',
          'Share': 'Share',
          'My Merchant': 'My Merchant',
          'My Order Detail': 'My Order Detail',
          'History Detail': 'History Detail',
          'Process': 'Process',
          'Completed': 'Completed',

          'Request': 'Request',
          'My Account': 'My Account',
          'Tray': 'Tray',
          'greeting': 'Hello',
          'main_page_title': 'Restonomous',
          'login': 'Login',
          'You are not logged in yet': 'You are not logged in yet',
          'Login now?': 'Login now?',
          'Cancel': 'Cancel',
          'Yes': 'Yes',
          'Loading....': 'Loading....',
          'Change': 'Change',
          'View All Menu': 'View All Menu',
          'no menu': 'No menus.',
          'tray': 'Food Tray',
          'Your tray is empty': 'Your tray is empty',
          "You haven't chosen a restaurant yet":
              "You haven't chosen a restaurant yet",
          "Let's choose the menu": "Let's choose the menu",
          "Category": "Category",
          "No categories yet": "No categories yet",
          "Close": "Close",
          "My Order": "My Order",
          "Logout": "Logout",
          'Put it in your tray': 'Put it in your tray',
          'Add': 'Add',
          'Out of stock': 'Out of stock',
          'Restaurant not selected': 'Restaurant not selected',
          'Login with Google': 'Login with Google',
          'Are you sure?': 'Are you sure?',
          'Do you want to exit an App': 'Do you want to exit an App',
          'No': 'No',

          //////// shoppingcart,checkout,myorder
          ///
          'Qty': 'Qty',
          'Change the qty': 'Change the qty',
          'No data yet': 'No data yet',
          'next': 'Next',
          'what will you do?': 'what will you do?',
          'Select': 'Select',
          'Delete': 'Delete',
          'Total orders': 'Total orders',

          'Table Number': 'Table Number',
          'Checkout': 'Checkout',
          'Notification': 'Notification',
          'Congratulations, we have received your order. We will process it immediately. Thank you':
              'Congratulations, we have received your order. We will process it immediately. Thank you',
          'History': 'History',
          'No order data yet': 'No order data yet',
          'Order Details': 'Order Details',
          'My Order History': 'My Order History',
/////////
          ///
          ///
          'Choose Restaurant': 'Choose Restaurant',
          'scan qr code': 'Scan QR Code',
          'no resto2':
              'There is no restaurant yet. Click the Scan QR code button, to add a restaurant.',
          'Select an image from Gallery / camera':
              'Select an image from Gallery / camera',

          'no resto':
              'No restaurant has been selected yet. Click the Change button, to select a restaurant.',
          'My Profile': 'My Profile',
          'Share App': 'Share App',
          'Terms and conditions': 'Terms and conditions',
          'Privacy Policy': 'Privacy Policy',

          'Your profile is not complete': 'Your profile is not complete',

          'Complete Now?': 'Complete Now?',
        },
        'id_ID': {
          'If not, leave it blank': 'Kalau tidak ada, biarkan kosong',
          'Name': 'Nama', 'Phone': 'Telepon', 'Address': 'Alamat',
          'from gallery': 'dari galeri',
          'from camera': 'dari camera',
          'See all categories': 'Lihat semua kategori',
          'Share': 'Bagikan',
          'My Merchant': 'Resto Favorit',
          'My Order Detail': 'Rincian Pesanan',
          'History Detail': 'Rincian Riwayat',
          'Request': 'Baru dipesan',
          'Process': 'Sedang diproses',
          'Completed': 'Selesai',
          'My Account': 'Akunku',
          'Tray': 'Nampan',
          'greeting': 'halo',
          'main_page_title': 'Restonomous',
          'login': 'Masuk',
          'You are not logged in yet': 'Kamu belum login',
          'Login now?': 'Login sekarang?',
          'Cancel': 'Batal',
          'Yes': 'Ya',
          'Loading....': 'Memuat....',
          'Change': 'Ubah',
          'View All Menu': 'Liat Semua Menu',
          'no menu': 'Belum ada menu',
          'tray': 'Nampan',
          'Your tray is empty': 'Nampan kamu kosong',
          "You haven't chosen a restaurant yet": "Kamu belum memilih resto",
          "Let's choose the menu": "Ayo pilih menunya",
          "Category": "Kategori",
          "No categories yet": "Belum ada kategori",
          "Close": "Tutup",
          "Logout": "Keluar",
          "My Order": "Pesananku",
          'Put it in your tray': 'Masukkan kenampan kamu',
          'Add': 'Tambahkan',
          'Out of stock': 'Habis',
          'Restaurant not selected': 'Resto belum dipilih',
          'Login with Google': 'Login dengan Google',
          'Are you sure?': 'Anda yakin?',
          'Do you want to exit an App': 'Anda ingin keluar aplikasi',
          'No': 'Tidak',

          //////
          ///
          ///
          'Qty': 'Jumlah',
          'Change the qty': 'Ubah jumlah',
          'No data yet': 'Belum ada data',
          'next': 'Lanjutkan',
          'what will you do?': 'Kamu mau melakukan apa?',
          'Select': 'Pilih',
          'Delete': 'Hapus',
          'Total orders': 'Total pesanan',

          'Table Number': 'Nomor Meja',
          'Checkout': 'Checkout',
          'Notification': 'Notifikasi',
          'Congratulations, we have received your order. We will process it immediately. Thank you':
              'Selamat, pesanan kamu sudah kami terima. Segera kami proses. Terimakasih',
          'History': 'Riwayat',
          'No order data yet': 'Belum ada data pesanan',
          'Order Details': 'Detail Pesanan',
          'My Order History': 'Riwayat Pesananku',
//////
          ///
          ///
          'Choose Restaurant': 'Pilih Resto',
          'scan qr code': 'Pindai QR Code',
          'no resto2':
              'Belum ada resto. Klik tombol Pindai QR code, untuk menambahkan resto.',
          'Select an image from Gallery / camera':
              'Pilih gambar dari galerigaleri / kamera',

          'no resto': 'Klik tombol Ubah, untuk memilih resto.',
          'My Profile': 'Profil',
          'Share App': 'Bagikan App',
          'Terms and conditions': 'Syarat & Ketentuan',
          'Privacy Policy': 'Kebijakan Privasi',
          'Your profile is not complete': 'Profil kamu belum lengkap',
          'Complete Now?': 'Lengkapi sekarang?',
        },
      };
}
