----------経過表一覧メイン画面用----------
select
	z_InvoiceKanri.Z_COMBINEKBN,
	z_InvoiceKanri.Z_CONSOLIDATIONKBN,

	SalesQuotationTable.QUOTATIONSTATUS,
	SalesTable.SALESSTATUS,
	SalesQuotationTable.Z_DEPARTMENT,
	SalesTable.Z_DEPARTMENT,

	z_InvoiceKanri.Z_INVOICENO,
	z_InvoiceKanri.Z_OYAINVOICENO,
	z_InvoiceKanri.Z_CONSOLIDATIONNO,
	z_InvoiceKanri.Z_QUOTATIONID,
	z_InvoiceKanri.Z_SALESID,

	CustInvoiceJour.INVOICEID,
	SalesTable.PURCHORDERFORMNUM,
	LogisticsPostalAddress.COUNTRYREGIONID,
	SalesTable.CUSTACCOUNT,
	SalesTable.SALESNAME,
	SalesTable.Z_JUYOKACD,
	coalesce(subQry_JyuyoKaName.NAME, '') as JyuyoKaName,
	coalesce(subQry_NijitenName.NAME, '') as NijitenName,

	SalesTable.SHIPPINGDATEREQUESTED,
	SalesTable.RECEIPTDATEREQUESTED,
	SalesTable.SHIPPINGDATECONFIRMED,
	SalesTable.RECEIPTDATECONFIRMED,

	LogisticsPostalAddress.DISTRICTNAME,
	LogisticsPostalAddress.ZIPCODE,
	LogisticsPostalAddress.STATE,
	LogisticsPostalAddress.CITY,
	LogisticsPostalAddress.STREET,
	LogisticsPostalAddress.BUILDINGCOMPLIMENT,

	CustInvoiceJour.INVOICEAMOUNT,
	subQry_Amount.max_lineNum,
	subQry_Amount.sum_InvoiceAmount

from
 Z_INVOICENOKANRI as z_InvoiceKanri


left join
 Z_YUSHUTSUKANRI as z_YushutsuKanri
on
 z_InvoiceKanri.Z_INVOICENO = z_YushutsuKanri.Z_COMMONINVOICENO


left join
 SALESQUOTATIONTABLE as SalesQuotationTable
on
 z_InvoiceKanri.Z_QUOTATIONID = SalesQuotationTable.QUOTATIONID


left join
 SALESTABLE as SalesTable
on
 z_InvoiceKanri.Z_SALESID = SalesTable.SALESID


left join
	LOGISTICSPOSTALADDRESS LogisticsPostalAddress
on
	SalesTable.DELIVERYPOSTALADDRESS = LogisticsPostalAddress.RECID


left join
	(
	select
		smmBusRelTable.BUSRELACCOUNT,
		dirPartyTable.NAME
	from
		SMMBUSRELTABLE smmBusRelTable
	inner join
		DirPartyTable dirPartyTable
	on
		smmBusRelTable.PARTY = dirPartyTable.RECID
	) subQry_JyuyoKaName
on
	SalesTable.Z_JUYOKACD = subQry_JyuyoKaName.BUSRELACCOUNT


left join
	(
	select
		smmBusRelTable.BUSRELACCOUNT,
		dirPartyTable.NAME
	from
		SMMBUSRELTABLE smmBusRelTable
	inner join
		DirPartyTable dirPartyTable
	on
		smmBusRelTable.PARTY = dirPartyTable.RECID
	) subQry_NijitenName
on
	SalesTable.Z_NIJITENCD = subQry_NijitenName.BUSRELACCOUNT


left join
 CUSTINVOICEJOUR as CustInvoiceJour
on
 SalesTable.SALESID = CustInvoiceJour.SALESID


inner join
	(
	select
		max(custInvoiceJour.INVOICEID) as max_InvoiceId,
		max(custInvoiceTrans.LINENUM) as max_lineNum,
		sum(custInvoiceJour.INVOICEAMOUNT) as sum_InvoiceAmount

	from
		CUSTINVOICEJOUR as custInvoiceJour


	left join
		CUSTINVOICETRANS as custInvoiceTrans
	on
		custInvoiceJour.INVOICEID = custInvoiceTrans.INVOICEID


	where
		custInvoiceJour.DATAAREAID = 'usmf'
	and
		custInvoiceTrans.DATAAREAID = 'usmf'


	group by
		custInvoiceJour.SALESID
	) subQry_Amount
on
	CustInvoiceJour.INVOICEID = subQry_Amount.max_InvoiceId


where
	z_InvoiceKanri.DATAAREAID = 'usmf'
and
	z_YushutsuKanri.DATAAREAID = 'usmf'
and
	SalesQuotationTable.DATAAREAID = 'usmf'
and
	SalesTable.DATAAREAID = 'usmf'
and
	CustInvoiceJour.DATAAREAID = 'usmf'


order by
 z_InvoiceKanri.Z_INVOICENO;