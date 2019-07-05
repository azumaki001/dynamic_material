--CustInvoiceJour顧客請求書仕訳帳（請求書ヘッダ）
select
	SALESID,
	INVOICEID,
	INVOICEDATE,
	NUMBERSEQUENCEGROUP
from
	CustInvoiceJour
where
	DATAAREAID = 'usmf'
and
	--SALESID in ()
	SALESID in (000002,000786)
order by
	SALESID,INVOICEID;

update
	CUSTINVOICEJOUR
set
	INVOICEID = 'CIV-000001'
where
	RECID in (68719508850,68719508849);



--CustInvoiceTrans
select
	SALESID,
	INVOICEID,
	INVOICEDATE,
	NUMBERSEQUENCEGROUP
from
	CustInvoiceTrans
where
	DATAAREAID = 'usmf'
and
	--SALESID in ()
	SALESID in (000002,000786)



--CustInvoiceSalesLink
select
	*
from
	CustInvoiceSalesLink
where
	DATAAREAID = 'usmf'
and
	SALESID between '000001' and '000006'
order by
	SALESID,INVOICEID;


--Z_InvoiceNoKanri
select
	*
from
	Z_InvoiceNoKanri
where
	DATAAREAID = 'usmf'



--OyaInvoiceNo単位での合計金額
select
	Z_InvoiceNoKanri.Z_INVOICENO,
	Z_InvoiceNoKanri.Z_OYAINVOICENO,
	CustInvoiceJour.SALESID,
	CustInvoiceJour.INVOICEAMOUNT,
	zasv.*
from
	Z_INVOICENOKANRI Z_InvoiceNoKanri
left join
	CUSTINVOICEJOUR CustInvoiceJour
on
	Z_InvoiceNoKanri.Z_SALESID = CustInvoiceJour.salesId
inner join
	Z_AMOUNTCHECK_SUBQRY_VIEW zasv
on
	CustInvoiceJour.INVOICEID = zasv.max_invoiceid
where
	Z_InvoiceNoKanri.DATAAREAID = 'usmf'
and
	CustInvoiceJour.DATAAREAID = 'usmf'
and
	zasv.DATAAREAID = 'usmf'
and
	CustInvoiceJour.salesid = '000002';



--SalesTableのcontactPersonIdがあるレコード
select
	SALESID,
	CONTACTPERSONID
from
	SALESTABLE
where
--	DATAAREAID = 'usmf'
--and
	CONTACTPERSONID <> null

--LOGISTICSPOSTALADDRESS
select
	salesTable.SALESID,
	LogisticsPostalAddress.*
from
	SALESTABLE salesTable
inner join
	LOGISTICSPOSTALADDRESS LogisticsPostalAddress
on
	salesTable.DELIVERYPOSTALADDRESS = LogisticsPostalAddress.RECID
where
	salesTable.SALESID = '000786'

update
	LOGISTICSPOSTALADDRESS
set
	DISTRICTNAME = 'districname',
	BUILDINGCOMPLIMENT = 'buildingName'
where
	recid = 22565424298;