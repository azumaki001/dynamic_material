----------経過表一覧メイン画面用----------
select
 z_InvoiceKanri.Z_INVOICENO,
 z_YushutsuKanri.Z_COMMONINVOICENO,
 SalesQuotationTable.QUOTATIONID,
 SalesTable.SALESID,

 --CustInvoiceSalesLink.ORIGSALESID,
 --CustInvoiceSalesLink.SALESID,

 CustInvoiceJour.INVOICEID,
 CustInvoiceJour.SALESID,
 CustInvoiceJour.INVOICEAMOUNT,

 --CustInvoiceTrans.SALESID,
 --CustInvoiceTrans.INVOICEID,
 --CustInvoiceTrans.ITEMID,
 --CustInvoiceTrans.LINENUM

 sub_Qry.max_lineNum,
 sub_Qry.sum_InvoiceAmount
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


--left join
-- CUSTINVOICESALESLINK as CustInvoiceSalesLink
--on
-- SalesTable.SALESID = CustInvoiceSalesLink.ORIGSALESID


--left join
-- CUSTINVOICEJOUR as CustInvoiceJour
--on
-- CustInvoiceSalesLink.INVOICEID = CustInvoiceJour.INVOICEID
--and
-- CustInvoiceSalesLink.SALESID = CustInvoiceJour.SALESID


left join
 CUSTINVOICEJOUR as CustInvoiceJour
on
 SalesTable.SALESID = CustInvoiceJour.SALESID


--left join
-- CUSTINVOICETRANS CustInvoiceTrans
--on
-- CustInvoiceJour.INVOICEID = CustInvoiceTrans.INVOICEID


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
	and
		custInvoiceJour.SALESID in ('000002', '000786')


	group by
		custInvoiceJour.SALESID
	) sub_Qry
on
	CustInvoiceJour.INVOICEID = sub_Qry.max_InvoiceId


where
 z_InvoiceKanri.DATAAREAID = 'usmf'
and
 z_InvoiceKanri.Z_OYAINVOICENO = 'O0001'
and
 z_YushutsuKanri.DATAAREAID = 'usmf'
and
 SalesQuotationTable.DATAAREAID = 'usmf'
and
 SalesTable.DATAAREAID = 'usmf'
--and
-- CustInvoiceSalesLink.DATAAREAID = 'usmf'
and
 CustInvoiceJour.DATAAREAID = 'usmf'
--and
-- CustInvoiceTrans.DATAAREAID = 'usmf'
and
	z_InvoiceKanri.Z_SALESID in ('000002','000786')


order by
 z_InvoiceKanri.Z_INVOICENO;



----------CustInvoiceTrans請求所単位での合計----------
select
	INVOICEID,
	sum(INVOICEAMOUNT) as sum_amount
from
(
select
	*
from
	CustInvoiceJour
where
	DATAAREAID = 'usmf'
and
	SALESID in ('000002','000786')
) sumTable
group by
	INVOICEID




--最大の請求書No
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
and
	custInvoiceJour.SALESID in ('000002', '000786')


group by
 custInvoiceJour.SALESID



--メインテーブルから最大でないレコードを除外
select
 z_InvoiceKanri.*,
 max_InvoiceIds.max_InvoiceId
from
 Z_INVOICENOKANRI as z_InvoiceKanri
inner join
 (
  select
    z_InvoiceKanri.Z_INVOICENO,
	max(CustInvoiceSalesLink.INVOICEID) as max_InvoiceId
  from
    Z_INVOICENOKANRI as z_InvoiceKanri
   left join
    CUSTINVOICESALESLINK as CustInvoiceSalesLink
   on
     z_InvoiceKanri.Z_SALESID = CustInvoiceSalesLink.ORIGSALESID
   where
     z_InvoiceKanri.DATAAREAID = 'usmf'
   and
     CustInvoiceSalesLink.DATAAREAID = 'usmf'
   group by
     z_InvoiceKanri.Z_INVOICENO
 ) max_InvoiceIds
on
 z_InvoiceKanri.Z_INVOICENO = max_InvoiceIds.Z_INVOICENO
where
 z_InvoiceKanri.DATAAREAID = 'usmf'


--CustInvoiceJour請求書が複数あるレコードを抜き出す
select
	Salesid
from
	CustInvoiceJour
where
	DATAAREAID = 'usmf'
group by
	Salesid
having
	count(Salesid) > 1;