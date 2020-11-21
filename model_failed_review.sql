-- Query to pull failed classifications with fail notes (causes duplication)
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--select *
SELECT distinct cc.COClientAcronym AS [Client], pn.PNumber AS [Part Number], pd.PDescriptionText AS [Part Description], SUBSTRING(HNumber, 1, 6) AS HS_Code, CHistoryOtherReference, --ssp.SYSubProcessName AS [Commodity], --s.SAdded AS [Status Updated], 
      uc.UEmail AS [Classifier], CAST(n.NText AS varchar(max)) AS [Fail notes], uf.UEmail AS [TA], ch.CHistoryStateID

FROM t_PART p
JOIN t_COMPClients cc ON cc.COClientID=p.COClientID --AND cc.COClientAcronym LIKE 'Client's Name'
JOIN t_CLASS c ON c.PID=p.PID
JOIN t_STAT s ON s.WID=c.CID --AND s.SYTableID=5 AND s.STypeID=7
JOIN t_CLASSHistory ch ON ch.CID=c.CID --AND (ch.CHistoryStateID=0 OR ch.CHistoryStateID=4)
JOIN t_HTS h ON h.HID=ch.HID AND h.SYSubprocessID=s.SYSubProcessID
LEFT JOIN t_NOTE n ON n.ForeignID=c.CID AND n.NTypeID=61

JOIN t_WORKAssignments wa ON wa.WID=c.CID AND wa.SYSubProcessID=s.SYSubProcessID --IN (SELECT SYSubProcessID FROM t_SYSSubProcesses WHERE SYProcessID=3)
JOIN t_WORKAssignmentActivity waa ON waa.WAssignmentID=wa.WAssignmentID AND waa.WAssignmentActivityCurrent=1
JOIN t_WORKPools wp ON wp.WPoolID=waa.WPoolID

JOIN t_PARTNumbers pn ON pn.PID=p.PID AND pn.PNumberMaster=1 AND pn.PNumberInvalid=0
JOIN t_PARTDescriptions pd ON pd.PID=p.PID AND pd.PDescriptionMaster=1 AND pd.PDescriptionInvalid=0
JOIN t_SYSSubProcesses ssp ON ssp.SYSubProcessID=s.SYSubProcessID AND ssp.SYSubProcessName NOT LIKE '%ECCN%' AND ssp.SYSubProcessName NOT LIKE '%ECN%' and ssp.SYSubProcessName NOT LIKE 'US Schedule B'
JOIN t_USER uc ON uc.UID=ch.UID
LEFT JOIN t_USER uf ON uf.UID=n.UID
where
--CHistoryDate >= '2010-03-27'
CHistoryDate between '2019-01-01' and '2019-12-31'
and uf.UEmail is not NULL
--and uf.UEmail in ('ppaluch@sttas.com', 'tzdravkov@sttas.com', 'mperkowski@sttas.com', 'dquinn@sttas.com', 'jsmith@sttas.com')
--and uc.UEmail in ('udarhevich@sttas.com')
--and uc.UEmail in ('bkoblianidze@sttas.com')
and ch.CHistoryStateID in ('0', '4')
--and COClientAcronym in ('Client's Name')

ORDER BY cc.COClientAcronym, pn.PNumber

