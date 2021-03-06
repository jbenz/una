<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    UnaCore UNA Core
 * @{
 */

/**
 * @see BxDolReport
 */
class BxDolReportQuery extends BxDolObjectQuery
{
    public function __construct(&$oModule)
    {
        parent::__construct($oModule);

        $this->_sMethodGetEntry = 'getReport';
    }

    public function getSqlParts($sMainTable, $sMainField)
    {
    	$aResult = parent::getSqlParts($sMainTable, $sMainField);
        if(empty($aResult))
            return $aResult;

		$aResult['fields'] = ", `{$this->_sTable}`.`count` as `report_count` ";
        return $aResult;
    }

    public function isPerformed($iObjectId, $iAuthorId)
    {
    	/*
    	 * 'false' is returned everytime to allow multiple reports for everybody.
    	 */
        return false;
    }

    public function getPerformedBy($iObjectId, $iStart = 0, $iPerPage = 0)
    {
        $sLimitClause = "";
        if(!empty($iPerPage))
            $sLimitClause = $this->prepareAsString(" LIMIT ?, ?", $iStart, $iPerPage);

        $sQuery = $this->prepare("SELECT `author_id`, `type`, `text` FROM `{$this->_sTableTrack}` WHERE `object_id`=? ORDER BY `date` DESC" . $sLimitClause, $iObjectId);
        return $this->getAll($sQuery);
    }

    public function getReport($iObjectId)
    {
        $sQuery = $this->prepare("SELECT `count` as `count` FROM {$this->_sTable} WHERE `object_id` = ? LIMIT 1", $iObjectId);

        $aResult = $this->getRow($sQuery);
        if(empty($aResult) || !is_array($aResult))
            $aResult = array('count' => 0);

        return $aResult;
    }

	public function putReport($iObjectId)
    {
        $sQuery = $this->prepare("SELECT `object_id` FROM `{$this->_sTable}` WHERE `object_id` = ? LIMIT 1", $iObjectId);
        $bExists = (int)$this->getOne($sQuery) != 0;

        if(!$bExists)
            $sQuery = $this->prepare("INSERT INTO `{$this->_sTable}` SET `object_id` = ?, `count` = '1'", $iObjectId);
        else
            $sQuery = $this->prepare("UPDATE `{$this->_sTable}` SET `count` = `count` + 1 WHERE `object_id` = ?", $iObjectId);

        return (int)$this->query($sQuery) != 0;
    }
    
    public function clearReports($iObjectId)
    {
        $sQuery = $this->prepare("DELETE FROM `{$this->_sTable}` WHERE `object_id` = ?", $iObjectId);
        $this->query($sQuery);
        
        $sQuery = $this->prepare("DELETE FROM `{$this->_sTableTrack}` WHERE `object_id` = ?", $iObjectId);
        $this->query($sQuery);
        
        $sQuery = $this->prepare("UPDATE `{$this->_sTriggerTable}` SET `{$this->_sTriggerFieldCount}` = 0 WHERE `{$this->_sTriggerFieldId}` = ?", $iObjectId);
        $this->query($sQuery);
    }
}

/** @} */
