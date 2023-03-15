import 'package:google_bilingual_annotations/google_bilingual_annotations.dart';
import 'package:googleapis/sheets/v4.dart';
import "package:googleapis_auth/auth_io.dart";

class TranslationItem {
  String msgid;
  String msgctxt;
  final String zh;
  final String en;

  TranslationItem(this.msgid, this.msgctxt, this.zh, this.en);

  String formatMsgid() => msgid.isEmpty ? '' : '"$msgid"';
  String formatMsgctxt() => msgctxt.isEmpty ? '' : '"$msgctxt"';
}

class GoogleSheet {
  final GoogleCredential credential;
  const GoogleSheet(this.credential);

  Future<AutoRefreshingAuthClient> startAuth() {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": credential.private_key_id,
      "private_key": credential.private_key,
      "client_email": credential.client_email,
      "client_id": credential.client_id,
      "type": credential.type
    });
    var scopes = [
      SheetsApi.driveFileScope,
      SheetsApi.driveReadonlyScope,
      SheetsApi.spreadsheetsScope,
      SheetsApi.driveScope,
      SheetsApi.spreadsheetsReadonlyScope
    ];
    return clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<List<TranslationItem>> getAllTranslations() async {
    return startAuth().then((value) {
      return SheetsApi(value)
          .spreadsheets
          .values
          .get(credential.file_id, credential.sheet_name)
          .then((value) {
        List<List<Object?>> items = value.values ?? [];
        return items.map((e) {
          String msgid = (e.isNotEmpty) ? (e[0]?.toString() ?? '') : '';
          String msgctxt = (e.length > 1) ? (e[1]?.toString() ?? '') : '';
          String zh = (e.length > 2) ? e[2]?.toString() ?? '' : '';
          String en = (e.length > 3) ? e[3]?.toString() ?? '' : '';
          return TranslationItem(msgid, msgctxt, zh, en);
        }).toList();
      });
    });
  }

  Future<AppendValuesResponse> append(List<TranslationItem> items) {
    return startAuth().then((value) {
      return SheetsApi(value).spreadsheets.values.append(
          ValueRange(
              values: items.map((e) {
            String msgid = e.msgid.isNotEmpty
                ? e.msgid.substring(1, e.msgid.length - 1)
                : e.msgid;
            String msgctxt = e.msgctxt.isNotEmpty
                ? e.msgctxt.substring(1, e.msgctxt.length - 1)
                : e.msgctxt;
            return [msgid, msgctxt, '', ''];
          }).toList()),
          credential.file_id,
          credential.sheet_name,
          valueInputOption: 'RAW');
    });
  }

  Future<BatchUpdateSpreadsheetResponse> delete(List<int> range) {
    List<Request> requests = [];
    for (var row in range.reversed) {
      if (row == 0) {
        continue;
      }
      Request request = Request(
          deleteDimension: DeleteDimensionRequest(
              range: DimensionRange(
                  dimension: 'ROWS',
                  sheetId: int.parse(credential.sheet_id),
                  startIndex: row,
                  endIndex: row + 1)));
      requests.add(request);
    }
    if (requests.isEmpty) {
      return Future.value(BatchUpdateSpreadsheetResponse());
    }
    return startAuth().then((value) {
      return SheetsApi(value).spreadsheets.batchUpdate(
          BatchUpdateSpreadsheetRequest(requests: requests),
          credential.file_id);
    });
  }
}
