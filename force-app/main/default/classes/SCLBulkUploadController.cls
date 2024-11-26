public with sharing class SCLBulkUploadController {
    public class RowMessage {
        @AuraEnabled
        public integer Row {get;set;}
        @AuraEnabled
        public string Message {get;set;}
    }

    public class SkuError {
        public SkuError() {
            Messages = new List<string>();
            FieldNames = new List<string>();
        }

        @AuraEnabled
        public string Id {get;set;}
        @AuraEnabled
        public string Title {get;set;}
        @AuraEnabled
        public List<string> Messages {get;set;}
        @AuraEnabled
        public List<string> FieldNames {get;set;}
    }

    public class ScSkuResult {
        public ScSkuResult(string fn, List<SCSkus__c> records) {
            if (records==null || records.size()==0) { throw new CSVException('No records to Save.'); }
            Filename = fn;
            Uploaded = false;
            Parsed = true;
            skus = records;
            Errors = new List<SkuError>();
        }

        public ScSkuResult(string fn) {
            Filename = fn;
            Uploaded = false;
            Parsed = false;
            skus = new List<SCSkus__c>();
            Errors = new List<SkuError>();
        }

        private Id rtId = Schema.SObjectType.SCSkus__c.getRecordTypeInfosByDeveloperName().get('Mass_load_store_increase').getRecordTypeId();
        private string[] header {get;set;}
        
        private string Delimiter =',';

        @AuraEnabled
        public string Filename {get; set;}

        @AuraEnabled
        public List<SCSkus__c> skus {get; set;}

        @AuraEnabled
        public List<SkuError> Errors {get; set;}
        
        @AuraEnabled
        public Boolean Uploaded {get; set;}

        @AuraEnabled
        public Boolean Parsed {get; set;}
        
        @AuraEnabled
        public List<RowMessage> Messages {get; set;}

        private void AddMessage(string m) {
            RowMessage rm = new RowMessage();
            rm.Message = m;
            AddMessage(rm);
        }

        private void AddMessage(RowMessage m) {
            if (Messages == null) { Messages = new List<RowMessage>(); }
            Messages.add(m);
        }

        public void SaveRecords() {
            try {
                Savepoint sp = database.setSavePoint();

                Database.SaveResult[] srList = database.insert(skus, false); //All or None  false; catch this logic below or an exception is thrown...

                boolean failed = false;
                integer i = 0;
                for (Database.SaveResult sr: srList) {
                    skus[i].Id = null; //If insert was successful, the ID is set, we need to null since its being rolled back below...
                    if (!sr.isSuccess()) {
                        failed = true;

                        SkuError e = new SkuError();
                        e.Id = 'row-' + string.valueOf(i);
                        e.Title = 'Please correct.';
                        for(Database.Error err : sr.getErrors()) {
                            e.Messages.add(err.getMessage());
                            e.FieldNames.addAll(err.getFields());
                        }
                        system.debug(e);
                        Errors.add(e);
                    }
                    i++;
                }

                if (failed) {
                    Database.rollback(sp);
                }
                else {
                    AddMessage(string.valueOf(skus.size()) + ' Record(s) Uploaded.');
                    skus = null;
                    Uploaded = true;
                }
            }
            catch(DMLException dex) {
                AddMessage(dex.getMessage());
                system.debug(dex.getMessage());
            }            
        }

        private string blankrowtemplate = ',,,,,,,,,,,,,,,,,,';
        public void ProcessFile(Id supplyChainId, Blob b) {
            try {
                Parsed = true;
                system.debug('Processing File');
                String[] lines = b.toString().split('\r\n');
                if (lines.size()>201) { throw new CSVException('Too many records. Due to Salesforce limitations, we cap at 200 records to help limit exceptions.'); }
        
                header = lines[0].split(Delimiter);
                ValidateHeader(header);
        
                for (Integer row = 1; row < lines.size(); row++) {
                    if (lines[row]==blankrowtemplate) { continue; }
                    if (!add(row, supplyChainId, lines[row])) {
                        Parsed = false;
                    }
                }
        
                if (Parsed) {
                    AddMessage('Records Parsed.');
                    SaveRecords();
                }
            }
            catch(Exception ex) {
                Parsed = false;
                AddMessage(ex.getMessage());
                system.debug(ex.getMessage());
            }
        }

        private boolean add(integer rowNum, Id supplyChainId, string line) {
            try {
                String[] data = line.split(Delimiter);
                integer sz = line.countMatches(Delimiter)-data.size() + 1;
                if (sz > 0) {
                    //If there's nothing in the last column(s), ensure we add a blank as it will be dropped during split
                    for(integer i = 1; i<=sz; i++ ) {
                        data.add('');
                    }
                }
                ValidateRow(data);
                
                SCSkus__c a = new SCSkus__c();
                a.recordtypeid = rtId;
                a.supplychain__c = supplyChainId;

                a.storea__c = GetColumn(header, data, 0);
                a.Has_store_opened_in_last_12_months__c = GetColumn(header, data, 1);
                a.TypeofRequest__c = GetColumn(header, data, 2);
                a.reasonforrequest__c = GetColumn(header, data, 3);
                a.Material__c= GetColumn(header, data, 4);
                a.ProductDivision__c = GetColumn(header, data, 5);
                a.MaterialDescription__c = GetColumn(header, data, 6);                 
                a.jan__c = (string.ISBLANK(GetColumn(header, data, 7))) ? 0: Double.valueOf(GetColumn(header, data, 7));              
                a.feb__c = (string.ISBLANK(GetColumn(header, data, 8))) ? 0: Double.valueOf(GetColumn(header, data, 8));
                a.march__c = (string.ISBLANK(GetColumn(header, data, 9))) ? 0: Double.valueOf(GetColumn(header, data, 9));
                a.apr__c = (string.ISBLANK(GetColumn(header, data, 10))) ? 0: Double.valueOf(GetColumn(header, data, 10));
                a.may__c = (string.ISBLANK(GetColumn(header, data, 11))) ? 0: Double.valueOf(GetColumn(header, data, 11));
                a.june__c = (string.ISBLANK(GetColumn(header, data, 12))) ? 0: Double.valueOf(GetColumn(header, data, 12));
                a.july__c = (string.ISBLANK(GetColumn(header, data, 13))) ? 0: Double.valueOf(GetColumn(header, data, 13));
                a.aug__c = (string.ISBLANK(GetColumn(header, data, 14))) ? 0: Double.valueOf(GetColumn(header, data, 14));
                a.sept__c = (string.ISBLANK(GetColumn(header, data, 15))) ? 0: Double.valueOf(GetColumn(header, data, 15));
                a.oct__c = (string.ISBLANK(GetColumn(header, data, 16))) ? 0: Double.valueOf(GetColumn(header, data, 16));
                a.nov__c = (string.ISBLANK(GetColumn(header, data, 17))) ? 0: Double.valueOf(GetColumn(header, data, 17));
                a.dec__c = (string.ISBLANK(GetColumn(header, data, 18))) ? 0: Double.valueOf(GetColumn(header, data, 18));

                a.name = a.Material__c;

                skus.add(a);
                return true;
            }
            catch(Exception ex) {
                RowMessage rm = new RowMessage();
                rm.Row = rowNum;
                rm.Message = ex.getMessage();
                AddMessage(rm);
                system.debug(rowNum + ': ' + rm.Message);
                system.debug(line);
            }
            return false;
        }
    }

    @AuraEnabled
    public static ScSkuResult uploadFile(String recordId, String filename, String base64Data, String contentType) { 
        system.debug('File Uploaded: ' + filename);
        ScSkuResult r = new ScSkuResult(filename);
        r.ProcessFile(Id.valueof(recordId), EncodingUtil.base64Decode(EncodingUtil.urlDecode(base64Data, 'UTF-8')));
        return r;
    }

    @AuraEnabled
    public static ScSkuResult saveRecords(String filename, List<SCSkus__c> records) { 
        system.debug('Records Uploaded');
        ScSkuResult r = new ScSkuResult(filename, records);
        r.SaveRecords();
        return r;
    }

    public class CSVException extends Exception{}

    private static string[] ColumnNames = new string[]{
        'Plant',
        'Is your store NEW?(<12 mos OLD)',
        'Type of Request',
        'Reason for Request',
        'Material #',
        'Product Division',
        'Material Description',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
    };

    private static void ValidateHeader(string[] header) {
        system.debug('Validate Header');
        ValidateRow(header);

        for(string h : header) {
            boolean found = false;
            for(string col : ColumnNames) {
                if (h.equalsIgnoreCase(col)) {
                    found = true;
                    break;
                }
            }

            if (!found) { throw new CSVException('Header mismatch error. Please verify column headings are correct. (' + h + ')'); } 
        }
    }

    private static void ValidateRow(string[] data) {
        system.debug('Validate Row');
        if (data == null || data.size()==0) { throw new CSVException('Row is null or empty'); }
        if (data.size()!=ColumnNames.size()) { throw new CSVException('Column Size mismatch: data[' + data.size() +'] vs. Cols[' + ColumnNames.size() +']'); }
    }

    private static integer GetColumnIndex(string[] header, string columnName) {
        for(integer h=0; h < header.size(); h++) {
            if (header[h].equalsIgnoreCase(columnName)) { return h; }
        }
        throw new CSVException('Column not found: ' + columnName);
    }

    private static string GetColumn(string[] header, string[] data, Integer columnNameIndex) {
        return data[GetColumnIndex(header, ColumnNames[columnNameIndex])];
    }

    private static string GetColumn(string[] header, string[] data, string columnName) {
        return data[GetColumnIndex(header, columnName)];
    }
}