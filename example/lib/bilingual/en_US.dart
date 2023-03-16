import 'package:flutter/material.dart';
import 'package:google_bilingual_annotations/google_bilingual_annotations.dart';

// ignore_for_file: constant_identifier_names
// ignore_for_file: camel_case_types
const Map<String, String> GOOGLE_SHEET_CREDENTIAL = {
  'private_key_id': 'bf752747cd1462ea706c9070785036292a0edfb5',
  'private_key':
      '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqsTfZZ0it8iVY\nMOA4zBPwpEuEClhVeHYxPStN9dJkyfZY07xbM1xmRAjSlm91ya3oNhLNcytAl1XS\nu8jcidqm2Et+T7nF4Rqi457CLEa26W9I6q5IgKFbf3tBxJGv0BRSqEc2U2bzsB2w\nnEYMofMc/xGyzq9253lpb4eJ0UgL0J55Lofhh67f/ld9zk4rTd5nHZPYgoRQ6Xy1\n/+uE48GzSL0gcsa015Il9Swn4JkJlWIRRUcafW0Vi0Vl4a9/rnyCDMBic+7o5mZ9\n3KtDLCM6Na3dkEQJyth4Whwms7VktHAHOrtYzHHpTH4VzteVsaHbM+jJO0SWOYH8\ncKhotrynAgMBAAECggEAHwhnOfxgJ1fN2FHSgiEAQxDrtc7XrnpfKqaPV/YoUTCy\nvAWKyh31X5Zg8EBvdT+8gWpLUtTseSrKbKy9YPMjMJBEcWt3P/WkDRdLBsxb8udP\n1zbrhrz0GRl9REDDp+4xs7FqeQMCxa0wSKqwxZ0wAQaSpiqTlg+RcEzZnIHTEmqI\nNODZAN/DXwRP7fEGye3B913lwjR+vAPomSiD+0MoRAHbmP5Oy9OYQcRoBRQISOtp\n2T05Iag0DITDrykAxcChRP65msvkQx2Aw4ZRJ28mU3gnC/05+3ZiXbkx2tANIOz1\nDW4lbmyWWXsQf8n0J7KG890K25FJC/Ig+Ha8tJyniQKBgQDc8K8o1CROHAjupb6d\nVL6HZdZUgSyinMfWGsGITuPfRV7BxVQJKqnld52bSsRWJ70hSAPDlo8EcIwZQD0B\n34uTgop83KB+drAVCbOzgtjTpoKR7Y/o75VGj1NWtoutzMt6YaQAYyonwT/cotRB\nTlPcwPCcpKPy0iIawLuPFjEpTQKBgQDFx0xugaFAQzlkEZm4NWghi9zkMoZ7s24a\nxvbb9t9CFFET8EZMvOW3vQCeWKEps8PISATaJcZHtpNwjv5WuMsIrQEqdZ184tgm\nVOsYrCTdQrtetiKPuiO9nAgiRuJ7dx8KAbxlvFTnV9MBxZo5xQU8UT6TnLas0RCd\nmbD91bnjwwKBgArz/6sFgVtB9otmOiHwnpV1zf9YfA7/uMR7hRat2owqEz2F+9mM\nfOm8WVrmhP9EbxLkUBN1NlfhAIEL9zpNi8zfTuBLy8UZOzd/yKHgncE4Ywa7AURq\nBDuARYBqAli2a2wAxTGjuOZJpVHZ3K30JSIvin4ph1s1Ya1z2piIYB2NAoGARi0f\nS56nbrvrozwzhQ8+MZkE+duLqFzUVp/+e7IvKa03z5FUAGqOQBHKJGViWf+1Gl2j\nixwYLN31ltzGFlNfh2aLoVs2VFfRRlifSpPaSMAi58pMnR75C5BPuonYVuK/mrde\n9+JJZgTdlCVfQdxMrUhOoeXbU5qjAKjGCmtJmC0CgYEArgiEo/7y/BeiGavmAQvv\n9vsAA0j7PKDnGE60C3OboC/vVBskVScckD6R3da8q3EUArLbDb7gC3pPvsf00S+s\nT5tL23MidJzBjE5J/oAL/y8aMvP4pnzgE06+8d01FJErvRKdXJV4Ma4MeaMWS8op\ndHUsw2FTmB+Al0GLtnoLvfI=\n-----END PRIVATE KEY-----\n',
  'client_email': 'coker-busy@busy-375613.iam.gserviceaccount.com',
  'client_id': '112920092832319622567',
  'type': 'service_account',
  'file_id': '1KrZdbOB-oieIKSMQj28dPwiP1RcuhW3-ZnrrGevGhpE',
  'sheet_name': 'Sheet2',
  'sheet_id': '1543276873'
};

@GoogleBilingual(['./lib'], 'en_US', GOOGLE_SHEET_CREDENTIAL)
const Locale en = Locale('en', 'US');
