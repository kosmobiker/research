SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT COClientAcronym,p.PID,PNumber, PDescriptionText, SUBSTRING(HNumber, 1, 6) AS HS, SYSubProcessName,UEmail, CHistoryOtherReference, WAssignmentActivityAdded, CHistoryClassificationStrength
--select *
FROM t_PART p
JOIN t_COMPClients cc ON cc.COClientID=p.COClientID --AND cc.COClientAcronym like 'client's name'
JOIN t_CLASS c ON c.PID=p.PID
JOIN t_STAT s ON s.WID=c.CID AND s.SYTableID not in ('2')
JOIN t_WORKAssignments wa ON wa.WID=c.CID AND wa.SYSubProcessID=s.SYSubProcessID 
JOIN t_WORKAssignmentActivity waa ON waa.WAssignmentID=wa.WAssignmentID AND WAssignmentActivityTypeID = 6
JOIN t_WORKPools wp ON wp.WPoolID=waa.WPoolID
JOIN t_PARTNumbers pn ON pn.PID=p.PID AND pn.PNumberMaster=1 AND pn.PNumberInvalid=0
JOIN t_PARTDescriptions pd ON pd.PID=p.PID AND pd.PDescriptionMaster=1 AND pd.PDescriptionInvalid=0
JOIN t_SYSSubProcesses ssp ON ssp.SYSubProcessID=s.SYSubProcessID AND ssp.SYSubProcessName NOT LIKE '%ECCN%' AND ssp.SYSubProcessName NOT LIKE '%ECN%' AND ssp.SYSubProcessName not in ('US Schedule B')
JOIN t_USER uc ON uc.UID=waa.UID
JOIN t_CLASSHistory ch ON ch.CID=c.CID AND ch.CHistoryStateID in ('1','3')
JOIN t_HTS h ON h.HID=ch.HID AND h.SYSubprocessID=s.SYSubProcessID

where
--PNumber in ('50-2784311207520')
--UEmail like ('dquinn@sttas.com' )
WAssignmentActivityAdded BETWEEN  '2020-01-01' and '2020-06-30'
--and COClientAcronym in ('client's name')
and UEmail in ('ppaluch@sttas.com', 'tzdravkov@sttas.com', 'mperkowski@sttas.com', 'dquinn@sttas.com', 'jsmith@sttas.com')
and CHistoryClassificationStrength in ('20', '55', '90', '91', '92', '95', '8', '100')
--and SYSubProcessName like 'US Import Tariff'
ORDER BY cc.COClientAcronym, pn.PNumber
