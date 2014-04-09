
-- SETTINGS

SET @iTypeOrder = (SELECT MAX(`order`) FROM `sys_options_types` WHERE `group` = 'modules');
INSERT INTO `sys_options_types`(`group`, `name`, `caption`, `icon`, `order`) VALUES 
('modules', 'bx_persons', '_bx_persons', 'bx_persons@modules/boonex/persons/|std-mi.png', IF(ISNULL(@iTypeOrder), 1, @iTypeOrder + 1));
SET @iTypeId = LAST_INSERT_ID();

INSERT INTO `sys_options_categories` (`type_id`, `name`, `caption`, `order`)
VALUES (@iTypeId, 'bx_persons', '_bx_persons', 1);
SET @iCategId = LAST_INSERT_ID();

INSERT INTO `sys_options` (`name`, `value`, `category_id`, `caption`, `type`, `extra`, `check`, `check_error`, `order`) VALUES
('bx_persons_autoapproval', 'on', @iCategId, '_bx_persons_option_autoapproval', 'checkbox', '', '', '', 1),
('bx_persons_default_acl_level', '2', @iCategId, '_bx_persons_option_default_acl_level', 'select', 'PHP:bx_import(''BxDolAcl''); return BxDolAcl::getInstance()->getMemberships(false, true);', '', '', 2);

-- STORAGES & TRANSCODERS

SET @iTotalPicturesSize = IFNULL((SELECT SUM(`size`) FROM `bx_persons_pictures`), 0);
SET @iTotalPicturesNum = IFNULL((SELECT COUNT(*) FROM `bx_persons_pictures`), 0);

SET @iTotalPicturesResizedSize = IFNULL((SELECT SUM(`size`) FROM `bx_persons_pictures_resized`), 0);
SET @iTotalPicturesResizedNum = IFNULL((SELECT COUNT(*) FROM `bx_persons_pictures_resized`), 0);

INSERT INTO `sys_objects_storage` (`object`, `engine`, `params`, `token_life`, `cache_control`, `levels`, `table_files`, `ext_mode`, `ext_allow`, `ext_deny`, `quota_size`, `current_size`, `quota_number`, `current_number`, `max_file_size`, `ts`) VALUES
('bx_persons_pictures', 'Local', '', 360, 2592000, 3, 'bx_persons_pictures', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, @iTotalPicturesSize, 0, @iTotalPicturesNum, 0, 0),
('bx_persons_pictures_resized', 'Local', '', 360, 2592000, 3, 'bx_persons_pictures_resized', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, @iTotalPicturesResizedSize, 0, @iTotalPicturesResizedNum, 0, 0);

INSERT INTO `sys_objects_transcoder_images` (`object`, `storage_object`, `source_type`, `source_params`, `private`, `atime_tracking`, `atime_pruning`, `ts`) VALUES 
('bx_persons_icon', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0'),
('bx_persons_thumb', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0'),
('bx_persons_avatar', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0'),
('bx_persons_picture', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0'),
('bx_persons_cover', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0'),
('bx_persons_cover_thumb', 'bx_persons_pictures_resized', 'Storage', 'a:1:{s:6:"object";s:19:"bx_persons_pictures";}', 'no', '1', '2592000', '0');

INSERT INTO `sys_transcoder_images_filters` (`transcoder_object`, `filter`, `filter_params`, `order`) VALUES 
('bx_persons_icon', 'Resize', 'a:4:{s:1:"w";s:2:"32";s:1:"h";s:2:"32";s:13:"square_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0'),
('bx_persons_thumb', 'Resize', 'a:4:{s:1:"w";s:2:"48";s:1:"h";s:2:"48";s:13:"square_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0'),
('bx_persons_avatar', 'Resize', 'a:4:{s:1:"w";s:2:"96";s:1:"h";s:2:"96";s:13:"square_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0'),
('bx_persons_picture', 'Resize', 'a:4:{s:1:"w";s:4:"1024";s:1:"h";s:4:"1024";s:13:"square_resize";s:1:"0";s:10:"force_type";s:3:"jpg";}', '0'),
('bx_persons_cover', 'Resize', 'a:4:{s:1:"w";s:4:"1024";s:1:"h";s:4:"1024";s:13:"square_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0'),
('bx_persons_cover_thumb', 'Resize', 'a:4:{s:1:"w";s:2:"48";s:1:"h";s:2:"48";s:13:"square_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0');

-- UPLOADERS

INSERT INTO `sys_objects_uploader` (`object`, `active`, `override_class_name`, `override_class_file`) VALUES
('bx_persons_avatar', 1, 'BxPersonsUploader', 'modules/boonex/persons/classes/BxPersonsUploader.php'),
('bx_persons_cover', 1, 'BxPersonsUploader', 'modules/boonex/persons/classes/BxPersonsUploader.php');

-- PAGES

--
-- Dumping data for 'bx_persons_create_profile' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_create_profile', 'create-persons-profile', '_bx_persons_page_title_sys_create_profile', '_bx_persons_page_title_create_profile', 'bx_persons', 5, 2147483647, 1, 'page.php?i=create-persons-profile', '', '', '', 0, 1, 0, '', '');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_create_profile', 1, 'bx_persons', '_bx_persons_page_block_title_create_profile', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:14:\"create_profile\";}', 0, 1, 1);

--
-- Dumping data for 'bx_persons_view_profile' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_view_profile', 'view-persons-profile', '_bx_persons_page_title_sys_view_profile', '_bx_persons_page_title_view_profile', 'bx_persons', 10, 2147483647, 1, 'page.php?i=view-persons-profile', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_view_profile', 1, 'bx_persons', '_bx_persons_page_block_title_profile_actions', 3, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:15:\"profile_actions\";}', 0, 0, 0),
('bx_persons_view_profile', 1, 'bx_persons', '_bx_persons_page_block_title_profile_cover', 3, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:13:\"profile_cover\";}', 0, 0, 1),
('bx_persons_view_profile', 2, 'bx_persons', '_bx_persons_page_block_title_profile_info', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:12:\"profile_info\";}', 0, 0, 0),
('bx_persons_view_profile', 3, 'bx_persons', '_bx_persons_page_block_title_profile_friends', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:15:\"profile_friends\";}', 0, 0, 0);

--
-- Dumping data for 'bx_persons_edit_profile' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_edit_profile', 'edit-persons-profile', '_bx_persons_page_title_sys_edit_profile', '_bx_persons_page_title_edit_profile', 'bx_persons', 5, 2147483647, 1, 'page.php?i=edit-persons-profile', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_edit_profile', 1, 'bx_persons', '_bx_persons_page_block_title_edit_profile', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:12:\"edit_profile\";}', 0, 0, 0);

--
-- Dumping data for 'bx_persons_edit_profile_cover' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_edit_profile_cover', 'edit-persons-cover', '_bx_persons_page_title_sys_edit_profile_cover', '_bx_persons_page_title_edit_profile_cover', 'bx_persons', 5, 2147483647, 1, 'page.php?i=edit-persons-cover', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_edit_profile_cover', 1, 'bx_persons', '_bx_persons_page_block_title_edit_profile_cover', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:10:\"edit_cover\";}', 0, 0, 0);

--
-- Dumping data for 'bx_persons_delete_profile' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_delete_profile', 'delete-persons-profile', '_bx_persons_page_title_sys_delete_profile', '_bx_persons_page_title_delete_profile', 'bx_persons', 5, 2147483647, 1, 'page.php?i=delete-persons-profile', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_delete_profile', 1, 'bx_persons', '_bx_persons_page_block_title_delete_profile', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:14:\"delete_profile\";}', 0, 0, 0);

--
-- Dumping data for 'bx_persons_profile_info' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_profile_info', 'persons-profile-info', '_bx_persons_page_title_sys_profile_info', '_bx_persons_page_title_profile_info', 'bx_persons', 5, 2147483647, 1, 'page.php?i=persons-profile-info', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_profile_info', 1, 'bx_persons', '_bx_persons_page_block_title_profile_info', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:10:\"bx_persons\";s:6:\"method\";s:12:\"profile_info\";}', 0, 0, 1);

--
-- Dumping data for 'bx_persons_profile_friends' page
--
INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_profile_friends', 'persons-profile-friends', '_bx_persons_page_title_sys_profile_friends', '_bx_persons_page_title_profile_friends', 'bx_persons', 5, 2147483647, 1, 'page.php?i=persons-profile-friends', '', '', '', 0, 1, 0, 'BxPersonsPageProfile', 'modules/boonex/persons/classes/BxPersonsPageProfile.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_persons_profile_friends', 1, 'bx_persons', '_bx_persons_page_block_title_profile_friends', 11, 2147483647, 'service', 'a:3:{s:6:\"module\";s:6:\"system\";s:6:\"method\";s:17:\"connections_table\";s:5:\"class\";s:23:\"TemplServiceConnections\";}', 0, 0, 1);


-- Homepage
INSERT INTO `sys_pages_blocks` (`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES
('sys_home', 0, 'bx_persons', '_bx_persons_page_block_title_latest_persons', 0, 2147483647, 'service', 'a:2:{s:6:"module";s:10:"bx_persons";s:6:"method";s:21:"browse_recent_persons";}', 0, 1, 0);

-- MENU

--SET @iCreateProfileMenuOrder = (SELECT `order` FROM `sys_menu_items` WHERE `set_name` = 'sys_profiles_create' AND `active` = 1 ORDER BY `order` DESC LIMIT 1);
--INSERT INTO `sys_menu_items` (`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES
--('sys_profiles_create', 'bx_persons', 'create-person-profile', '_bx_persons_menu_item_title_system_persons_profile', '_bx_persons_menu_item_title_persons_profile', 'page.php?i=create-persons-profile', '', '', 'user', '', 2147483647, 1, 1, IFNULL(@iCreateProfileMenuOrder, 0) + 1);

SET @iAddMenuOrder = (SELECT `order` FROM `sys_menu_items` WHERE `set_name` = 'sys_add_content_links' AND `active` = 1 ORDER BY `order` DESC LIMIT 1);
INSERT INTO `sys_menu_items` (`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('sys_add_content_links', 'bx_persons', 'create-persons-profile', '_bx_persons_menu_item_title_system_create_person', '_bx_persons_menu_item_title_create_person', 'page.php?i=create-persons-profile', '', '', '', '', 2147483647, 1, 1, IFNULL(@iAddMenuOrder, 0) + 1);


--
-- Dumping data for 'bx_persons_view_actions' menu
--
INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_view_actions', '_bx_persons_menu_title_view_person_actions', 'bx_persons_view_actions', 'bx_persons', 9, 0, 1, 'BxPersonsMenuViewPerson', 'modules/boonex/persons/classes/BxPersonsMenuViewPerson.php');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_persons_view_actions', 'bx_persons', '_bx_persons_menu_set_title_view_person_actions', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_persons_view_actions', 'bx_persons', 'profile-friend-add', '_bx_persons_menu_item_title_system_befriend', '{title_add_friend}', 'javascript:void(0)', 'bx_conn_action(this, \'sys_profiles_friends\', \'add\', \'{profile_id}\')', '', 'plus', '', 2147483647, 1, 0, 10),
('bx_persons_view_actions', 'bx_persons', 'profile-subscribe-add', '_bx_persons_menu_item_title_system_subscribe', '_bx_persons_menu_item_title_subscribe', 'javascript:void(0)', 'bx_conn_action(this, \'sys_profiles_subscriptions\', \'add\', \'{profile_id}\')', '', 'check', '', 2147483647, 1, 0, 20),
('bx_persons_view_actions', 'bx_persons', 'profile-actions-more', '_bx_persons_menu_item_title_system_more_actions', '_bx_persons_menu_item_title_more_actions', 'javascript:void(0)', 'bx_menu_popup(''bx_persons_view_actions_more'', this, {}, {profile_id:{profile_id}});', '', 'cog', 'bx_persons_view_actions_more', 2147483647, 1, 0, 30);

--
-- Dumping data for 'bx_persons_view_actions_more' menu
--
INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_view_actions_more', '_bx_persons_menu_title_view_person_actions_more', 'bx_persons_view_actions_more', 'bx_persons', 6, 0, 1, 'BxPersonsMenuViewPerson', 'modules/boonex/persons/classes/BxPersonsMenuViewPerson.php');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_persons_view_actions_more', 'bx_persons', '_bx_persons_menu_set_title_view_person_actions_more', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_persons_view_actions_more', 'bx_persons', 'profile-friend-remove', '_bx_persons_menu_item_title_system_unfriend', '{title_remove_friend}', 'javascript:void(0)', 'bx_conn_action(this, \'sys_profiles_friends\', \'remove\', \'{profile_id}\')', '', 'minus', '', 2147483647, 1, 0, 10),
('bx_persons_view_actions_more', 'bx_persons', 'profile-subscribe-remove', '_bx_persons_menu_item_title_system_unsubscribe', '_bx_persons_menu_item_title_unsubscribe', 'javascript:void(0)', 'bx_conn_action(this, \'sys_profiles_subscriptions\', \'remove\', \'{profile_id}\')', '', 'check', '', 2147483647, 1, 0, 20),
('bx_persons_view_actions_more', 'bx_persons', 'edit-persons-profile', '_bx_persons_menu_item_title_system_edit_person', '_bx_persons_menu_item_title_edit_person', 'page.php?i=edit-persons-profile&id={content_id}', '', '', 'pencil', '', 2147483647, 1, 0, 30),
('bx_persons_view_actions_more', 'bx_persons', 'delete-persons-profile', '_bx_persons_menu_item_title_system_delete_person', '_bx_persons_menu_item_title_delete_person', 'page.php?i=delete-persons-profile&id={content_id}', '', '', 'remove', '', 2147483647, 1, 0, 40);


--
-- Dumping data for 'bx_persons_view_submenu' menu
--
INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_persons_view_submenu', '_bx_persons_menu_title_view_person_submenu', 'bx_persons_view_submenu', 'bx_persons', 8, 0, 1, 'BxPersonsMenuViewPerson', 'modules/boonex/persons/classes/BxPersonsMenuViewPerson.php');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_persons_view_submenu', 'bx_persons', '_bx_persons_menu_set_title_view_person_submenu', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_persons_view_submenu', 'bx_persons', 'persons-profile-info', '_bx_persons_menu_item_title_system_view_person_info', '_bx_persons_menu_item_title_view_person_info', 'page.php?i=persons-profile-info&id={content_id}', '', '', '', '', 2147483647, 1, 0, 0),
('bx_persons_view_submenu', 'bx_persons', 'persons-profile-friends', '_bx_persons_menu_item_title_system_view_person_friends', '_bx_persons_menu_item_title_view_person_friends', 'page.php?i=persons-profile-friends&id={content_id}', '', '', '', '', 2147483647, 1, 0, 1);


-- notifications menu in account popup
SET @iNotifMenuOrder = (SELECT `order` FROM `sys_menu_items` WHERE `set_name` = 'sys_account_notifications' AND `active` = 1 ORDER BY `order` DESC LIMIT 1);
INSERT INTO `sys_menu_items` (`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `addon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES
('sys_account_notifications', 'bx_persons', 'notifications-friend-requests', '_bx_persons_menu_item_title_system_friend_requests', '_bx_persons_menu_item_title_friend_requests', 'page.php?i=persons-profile-friends&id={profile_id}', '', '', 'users', 'a:4:{s:6:"module";s:6:"system";s:6:"method";s:21:"profile_notifications";s:6:"params";a:1:{i:0;s:20:"sys_profiles_friends";}s:5:"class";s:23:"TemplServiceConnections";}', '', 2147483646, 1, 0, IFNULL(@iAddMenuOrder, 0) + 1);


-- ACL

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_persons', 'create person profile', NULL, '_bx_persons_acl_action_create_profile', '', 1, 1);
SET @iIdActionProfileCreate = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_persons', 'delete person profile', NULL, '_bx_persons_acl_action_delete_profile', '', 1, 1);
SET @iIdActionProfileDelete = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_persons', 'view person profile', NULL, '_bx_persons_acl_action_view_profile', '', 1, 1);
SET @iIdActionProfileView = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_persons', 'edit any person profile', NULL, '_bx_persons_acl_action_edit_any_profile', '', 1, 1);
SET @iIdActionProfileEditAny = LAST_INSERT_ID();


SET @iUnauthenticated = 1;
SET @iStandard = 2;
SET @iUnconfirmed = 3;
SET @iPending = 4;
SET @iSuspended = 5;
SET @iModerator = 6;
SET @iAdministrator = 7;
SET @iPremium = 8;

INSERT INTO `sys_acl_matrix` (`IDLevel`, `IDAction`) VALUES

-- profile create
(@iStandard, @iIdActionProfileCreate),
(@iUnconfirmed, @iIdActionProfileCreate),
(@iPending, @iIdActionProfileCreate),
(@iModerator, @iIdActionProfileCreate),
(@iAdministrator, @iIdActionProfileCreate),
(@iPremium, @iIdActionProfileCreate),

-- profile delete
(@iStandard, @iIdActionProfileDelete),
(@iUnconfirmed, @iIdActionProfileDelete),
(@iPending, @iIdActionProfileDelete),
(@iModerator, @iIdActionProfileDelete),
(@iAdministrator, @iIdActionProfileDelete),
(@iPremium, @iIdActionProfileDelete),

-- profile view
(@iUnauthenticated, @iIdActionProfileView),
(@iStandard, @iIdActionProfileView),
(@iUnconfirmed, @iIdActionProfileView),
(@iPending, @iIdActionProfileView),
(@iModerator, @iIdActionProfileView),
(@iAdministrator, @iIdActionProfileView),
(@iPremium, @iIdActionProfileView),

-- any profile edit
(@iModerator, @iIdActionProfileEditAny),
(@iAdministrator, @iIdActionProfileEditAny);


-- VIEWS
INSERT INTO `sys_objects_view` (`name`, `table_track`, `period`, `is_on`, `trigger_table`, `trigger_field_id`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_persons', 'bx_persons_views_track', '86400', '1', 'bx_persons_data', 'id', 'views', '', '');
