<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    UnaView UNA Studio Representation classes
 * @ingroup     UnaStudio
 * @{
 */

class BxBaseStudioModule extends BxDolStudioModule
{
    protected $oHelper;

    protected $aMenuItems = array(
        BX_DOL_STUDIO_MOD_TYPE_SETTINGS => array('name' => BX_DOL_STUDIO_MOD_TYPE_SETTINGS, 'icon' => 'cogs', 'title' => '_adm_lmi_cpt_settings')
    );
    
    protected $sTmplNamePopupSettings;
    protected $sTmplNamePopupConfirmUninstall;

    function __construct($sModule, $mixedPageName, $sPage = "")
    {
        parent::__construct($sModule, $mixedPageName, $sPage);

        $this->oHelper = BxTemplStudioModules::getInstance();

        $this->sTmplNamePopupSettings = 'mod_popup_settings.html';
        $this->sTmplNamePopupConfirmUninstall = 'mod_popup_confirm_uninstall.html';
    }

    function getPageCss()
    {
        return array_merge(parent::getPageCss(), $this->oHelper->getCss());
    }

    function getPageJs()
    {
        return array_merge(parent::getPageJs(), $this->oHelper->getJs());
    }

    function getPageJsClass()
    {
        return $this->oHelper->getJsClass();
    }

    function getPageJsObject()
    {
        return $this->oHelper->getJsObject();
    }

    function getPageJsCode($aParams = array(), $mixedWrap = true)
    {
        return $this->oHelper->getJsCode($aParams, $mixedWrap);
    }

    function getPageCaption()
    {
        return BxDolStudioTemplate::getInstance()->parseHtmlByName('mod_page_caption.html', array(
            'js_object' => $this->getPageJsObject(),
            'content' => parent::getPageCaption(),
            'js_code' => $this->getPageJsCode()
        ));
    }

    function getPageAttributes()
    {
        if((int)$this->aModule['enabled'] == 0)
            return 'style="display:none"';

        return parent::getPageAttributes();
    }

    function getPageMenu($aMenu = array(), $aMarkers = array())
    {
        $sJsObject = $this->getPageJsObject();

        $aMenu = array();
        foreach($this->aMenuItems as $sName => $aItem)
            $aMenu[] = array(
                'name' => $sName,
                'icon' => $aItem['icon'],
                'link' => isset($aItem['link'])  ? $aItem['link'] : bx_append_url_params($this->sManageUrl, array('page' => $sName)),
                'title' => _t(!empty($aItem['title']) ? $aItem['title'] : $aItem['caption']),
                'selected' => $sName == $this->sPage
            );

        return parent::getPageMenu($aMenu);
    }

    function getPageCode()
    {
        $sResult = parent::getPageCode();
        if($sResult === false)
            return false;

        $sMethod = 'get' . ucfirst($this->sPage);
        if(!method_exists($this, $sMethod))
            return '';

        return $sResult . $this->$sMethod();
    }

    protected function getSettings()
    {
        $oPage = new BxTemplStudioSettings($this->sModule);

        return BxDolStudioTemplate::getInstance()->parseHtmlByName('module.html', array(
            'content' => $oPage->getFormCode(),
        ));
    }

    protected function getPopupSettings($sPage, $iWidgetId)
    {
        $sActions = $this->getPageActions($iWidgetId);
        if(empty($sActions))
            return '';

        $sName = 'bx-std-mod-popup-settings-' . $sPage;
        $sContent = BxDolStudioTemplate::getInstance()->parseHtmlByName($this->sTmplNamePopupSettings, array(
            'content' => $sActions
        ));

        return BxTemplStudioFunctions::getInstance()->transBox($sName, $sContent);
    }

    protected function getPopupConfirmUninstall($iWidgetId, &$aModule)
    {
        $sJsObject = $this->getPageJsObject();

        $sName = 'bx-std-mod-popup-confirm';
        $sContent = BxDolStudioTemplate::getInstance()->parseHtmlByName($this->sTmplNamePopupConfirmUninstall, array(
            'content' => _t('_adm_' . $this->sLangPrefix . '_cnf_uninstall', $aModule['title']),
            'click' => $sJsObject . ".uninstall('" . $aModule['name'] . "', " . $iWidgetId . ", 1)"
        ));

        return BxTemplStudioFunctions::getInstance()->transBox($sName, $sContent);
    }
}

/** @} */
