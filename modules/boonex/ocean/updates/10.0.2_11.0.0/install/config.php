<?php
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 */

$aConfig = array(
    /**
     * Main Section.
     */
    'title' => 'Ocean',
    'version_from' => '10.0.2',
    'version_to' => '11.0.0',
    'vendor' => 'BoonEx',

    'compatible_with' => array(
        '11.0.0-B1'
    ),

    /**
     * 'home_dir' and 'home_uri' - should be unique. Don't use spaces in 'home_uri' and the other special chars.
     */
    'home_dir' => 'boonex/ocean/updates/update_10.0.2_11.0.0/',
    'home_uri' => 'ocean_update_1002_1100',

    'module_dir' => 'boonex/ocean/',
    'module_uri' => 'ocean',

    'db_prefix' => 'bx_ocean_',
    'class_prefix' => 'BxOcean',

    /**
     * Installation/Uninstallation Section.
     */
    'install' => array(
        'execute_sql' => 0,
        'update_files' => 1,
        'update_languages' => 0,
        'clear_db_cache' => 0,
    ),

    /**
     * Category for language keys.
     */
    'language_category' => 'BoonEx Ocean',

    /**
     * Files Section
     */
    'delete_files' => array(),
);