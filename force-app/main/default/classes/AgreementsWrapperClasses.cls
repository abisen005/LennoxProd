//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class AgreementsWrapperClasses {
    
    public class VValidity {
        public String to;
        public String fromDate;
    }

    public class CDQType {
        public String VName;
        public String VLabel;
    }

    public class VCRM {
        public String VCRMID;
        public String displayName;
        public String VCRMName;
    }

    public class VSalesArea {
        public CDQType VDivision;
        public CDQType VSalesOrg;
        public CDQType VChannel;
    }

    public class Data {
        public String id;
        public String type;
        public Integer VVersionNumber;
        public VValidity VValidity;
        public String Description;
        public String lastModified;
        public CDQType CDQType;
        public VCRM VCRM;
        public Boolean flagged;
        public String VID;
        public CDQRevenue CDQRevenue;
        public VWaterfall VWaterfall;
        public String SFDCOppty;
        public String created;
        public VWorkflowOwner VWorkflowOwner;
        public String VNotes;
        public VCustomerSalesData VCustomerSalesData;
        public VState VState;
        public Decimal VScore;
        public String displayName;
        public Impact Impact;
        public SalesOffice SalesOffice;
        public SalesGroup SalesGroup;
        public MarketSegment MarketSegment;
        public String ProjectNumber;
        public SupportedPrice SupportedPrice;
        public GrossMarginP GrossMarginP;
        public PocketMarginP PocketMarginP;
        public Boolean VIsLatestRevision;
        /*public _links _links;
        public _rights _rights;
        public _limits _limits;*/
    }
    
    public class PocketMarginP {
        public Decimal Amount;
    }
    
    public class GrossMarginP {
        public Decimal Amount;
    }
    
    public class SupportedPrice {
        public Decimal Amount;
    }
    
    public class MarketSegment {
        public String VName;
    }
    
    public class SalesGroup {
        public String VName;
    }
    
    public class SalesOffice {
        public String VName;
    }
    
    public class Impact {
        public Decimal Amount;
    }

    public class CDQRevenue {
        public Double Amount;
    }

    public class VWaterfall {
        public CDQRevenue VPocketPrice;
        public VariablePocketMargin VariablePocketMargin;
    }
    
    public class VariablePocketMargin {
        public Decimal Amount;
    }

    public AgreementsPagingWrapperClass paging {get;set;}

    public class VWorkflowOwner {
        public String VName;
    }

    public List<Data> data;
    

    public class VCustomerSalesData {
        public VSalesArea VSalesArea;
        public String displayName;
        public VCustomer VCustomer;
    }

    public class VState {
        public String VName;
    }


    public class VCustomer {
        public String VName;
    }

    
    public static AgreementsWrapperClasses parse(String json) {
        return (AgreementsWrapperClasses) System.JSON.deserialize(json, AgreementsWrapperClasses.class);
    }
    
    
}