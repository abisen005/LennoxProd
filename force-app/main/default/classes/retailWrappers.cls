global class retailWrappers {
    global class retailChartValue {
        public String label {get;set;}
        public Decimal value {get;set;}
        public RetailChartValue(String label, Decimal value) {
            this.label = label;
            this.value = value;
        }
    }
    global class summarySalesData {
        public Integer numStores {get;set;}
        public Decimal avgYtdSales {get;set;}
        public Decimal avgMinTargetSales {get;set;}
        public Decimal avgPercentToTargetSales {get;set;}
        public Decimal ytdClosed {get;set;}
        public Decimal minTargetClosed {get;set;}
        public Decimal percentToTargetClosed {get;set;}
        public Decimal ytdSales {get;set;}
        public Decimal minTargetSales {get;set;}
        public Decimal percentToTargetSales {get;set;}
        public Decimal ytdChangeSales {get;set;}
        public Decimal ytdChangePercentage {get;set;}
        public String performanceRating {get;set;} //success, warning, danger
        public SummarySalesData(Decimal endYearSalesStoreTarget, Decimal curAvgSalesStoreTarget, Decimal curAvgProposalsStoreTarget, Integer numStores, Decimal avgSales, Decimal sumSales, Decimal avgClosed, Decimal ytdChange, Decimal sumPytdSales) {
            System.debug('ytdChange' + endYearSalesStoreTarget);
            System.debug('sumPytdSales' + curAvgProposalsStoreTarget);
            this.numStores = numStores;
            this.avgYtdSales = avgSales;
            this.avgMinTargetSales = curAvgSalesStoreTarget;
            this.avgPercentToTargetSales = avgMinTargetSales == 0 ? 0 : (avgYtdSales / avgMinTargetSales) * 100;
            this.ytdClosed = avgClosed;
            this.minTargetClosed = curAvgProposalsStoreTarget;
            this.percentToTargetClosed = minTargetClosed == 0 ? 0 : (ytdClosed / minTargetClosed) * 100;
            this.ytdSales = sumSales;
            this.minTargetSales = curAvgSalesStoreTarget * numStores;
            this.percentToTargetSales = minTargetSales == 0 ? 0 : (ytdSales / minTargetSales) * 100;
            this.ytdChangeSales = ytdChange;
            this.ytdChangePercentage = sumPytdSales == 0 ? 0 : (ytdChange / sumPytdSales) * 100;
            this.performanceRating = ytdChangePercentage > 0 && avgYtdSales >= curAvgSalesStoreTarget ? 'success' : ytdChangePercentage <= 0 && avgYtdSales < curAvgSalesStoreTarget ? 'danger' : 'warning';
        }
    }
    global class retailSummaryData {
        public Decimal totalLeads {get;set;} //only used in costco
        public Decimal ytdLeads {get;set;}   //for costco, this represents "confirmed" leads
        public Decimal ytdInHomes {get;set;}
        public Decimal ytdProposals {get;set;}
        public Decimal ytdProposalsClosed {get;set;}
        public Decimal ytdSales {get;set;}
        public Decimal priorYtdSales {get;set;}
        public Decimal annualStoreGoal {get;set;}

        public Decimal ytdChange {get;set;}
        public Decimal ytdChangePercentage {get;set;}

        public Decimal ldProposalSpillRatio {get;set;}
        public Decimal inHomeSpillRatio {get;set;}
        public Decimal inHomeConversionRatio {get;set;}
        public Decimal ldProposalRatio {get;set;}
        public Decimal proposalCloseRatio {get;set;}
        public Decimal percentToAnnualStoreGoal {get;set;}
        
        //costco specific
        public Decimal selfGenLeads {get;set;}
        public Decimal installs {get;set;}
        public Decimal selfGenLeadRatio {get;set;}
        public Decimal leadToInstallRatio {get;set;}

        public String performanceRating {get;set;} //success, warning, danger
        public Decimal avgSalesStoreTarget {get;set;}
        public Integer storeLength {get;set;}

        public RetailSummaryData(Decimal totalLeads, Decimal ytdLeads, Decimal ytdInHomes, Decimal ytdProposals, Decimal ytdProposalsClosed, Decimal ytdSales, Decimal priorYtdSales, Decimal selfGenLeads, Decimal installs, Decimal avgSalesStoreTarget, Boolean calc, Integer storeLength) {
            this.totalLeads = totalLeads;
            this.ytdLeads = ytdLeads;
            this.ytdInHomes = ytdInHomes;
            this.ytdProposals = ytdProposals;
            this.ytdProposalsClosed = ytdProposalsClosed;
            this.ytdSales = ytdSales;
            this.priorYtdSales = priorYtdSales;
            this.selfGenLeads = selfGenLeads;
            this.installs = installs;
            this.avgSalesStoreTarget = avgSalesStoreTarget;
            this.storeLength = storeLength == null ? 1 : storeLength;
            this.annualStoreGoal = this.annualStoreGoal == null ? 0 : this.annualStoreGoal;
            if(calc){
                this.ytdChange = ytdSales - priorYtdSales;
                this.ytdChangePercentage = priorYtdSales > 0 ? (ytdChange / priorYtdSales) * 100 : 100;
                this.ldProposalSpillRatio = ytdLeads > 0 ? ((ytdLeads - ytdProposals) / ytdLeads) * 100 : 0;
                this.ldProposalRatio = ytdLeads > 0 ? (ytdProposals / ytdLeads) * 100 : 0;
                this.proposalCloseRatio = ytdProposals > 0 ? (ytdProposalsClosed / ytdProposals) * 100 : 0;
                this.performanceRating = ytdChangePercentage > 0 && ytdSales >= (avgSalesStoreTarget * storeLength) ? 'success' : ytdChangePercentage <= 0 && ytdSales < (avgSalesStoreTarget * storeLength) ? 'danger' : 'warning';
                this.selfGenLeadRatio = totalLeads > 0 ? (selfGenLeads / totalLeads) * 100 : 0;
                this.leadToInstallRatio = ytdLeads > 0 ? (installs / ytdLeads) * 100 : 0;
                this.inHomeSpillRatio = ytdLeads > 0 ? ((ytdLeads - ytdInHomes) / ytdLeads) * 100 : 0;
                this.inHomeConversionRatio = ytdLeads > 0 ? (ytdInHomes / ytdLeads) * 100 : 0;
            }
        }
        public void calcRatios() {
            this.ytdChange = this.ytdSales - this.priorYtdSales;
            this.ytdChangePercentage = this.priorYtdSales > 0 ? (this.ytdChange / this.priorYtdSales) * 100 : 100;
            this.ldProposalSpillRatio = this.ytdLeads > 0 ? ((this.ytdLeads - this.ytdProposals) / this.ytdLeads) * 100 : 0;
            this.ldProposalRatio = this.ytdLeads > 0 ? (this.ytdProposals / this.ytdLeads) * 100 : 0;
            this.proposalCloseRatio = this.ytdProposals > 0 ? (this.ytdProposalsClosed / this.ytdProposals) * 100 : 0;
            this.percentToAnnualStoreGoal = this.annualStoreGoal > 0 ? (this.ytdSales / this.annualStoreGoal) * 100 : 0;
            this.selfGenLeadRatio = this.totalLeads > 0 ? (this.selfGenLeads / this.totalLeads) * 100 : 0;
            this.leadToInstallRatio = this.ytdLeads > 0 ? (this.installs / this.ytdLeads) * 100 : 0;
            this.inHomeSpillRatio = this.ytdLeads > 0 ? ((this.ytdLeads - this.ytdInHomes) / this.ytdLeads) * 100 : 0;
            this.inHomeConversionRatio = this.ytdLeads > 0 ? (this.ytdInHomes / this.ytdLeads) * 100 : 0;
        }
        public void setPerformanceRating(Integer storeLength) {
            this.storeLength = storeLength == null ? 1 : storeLength;
            this.performanceRating = this.ytdChangePercentage > 0 && this.ytdSales >= (this.avgSalesStoreTarget * storeLength) ? 'success' : this.ytdChangePercentage <= 0 && this.ytdSales < (this.avgSalesStoreTarget * storeLength) ? 'danger' : 'warning';
        }
        public void addVals(Decimal totalLeads, Decimal ytdLeads, Decimal ytdInHomes, Decimal ytdProposals, Decimal ytdProposalsClosed, Decimal ytdSales, Decimal priorYtdSales, Decimal annualStoreGoal, Decimal selfGenLeads, Decimal installs) {
            this.totalLeads += totalLeads == null ? 0 : totalLeads;
            this.ytdLeads += ytdLeads == null ? 0 : ytdLeads;
            this.ytdInHomes += ytdInHomes == null ? 0 : ytdInHomes;
            this.ytdProposals += ytdProposals == null ? 0 : ytdProposals;
            this.ytdProposalsClosed += ytdProposalsClosed == null ? 0 : ytdProposalsClosed;
            this.ytdSales += ytdSales == null ? 0 : ytdSales;
            this.priorYtdSales += priorYtdSales == null ? 0 : priorYtdSales;
            this.annualStoreGoal += annualStoreGoal == null ? 0 : annualStoreGoal;
            this.selfGenLeads += selfGenLeads == null ? 0 : selfGenLeads;
            this.installs += installs == null ? 0 : installs;
        }
    }
}