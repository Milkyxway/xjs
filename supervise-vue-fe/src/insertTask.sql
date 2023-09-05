CREATE TABLE `task_base`.`task_list` (
  `taskId` int NOT NULL AUTO_INCREMENT,
  `taskContent` varchar(400) DEFAULT NULL,
  `taskGoal` varchar(45) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `comment` varchar(45) DEFAULT NULL,
  `leadOrg` int DEFAULT NULL,
  `assistOrg` varchar(100) DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `children` int DEFAULT NULL,
  `updateTime` datetime DEFAULT NULL,
  `hasChildren` tinyint DEFAULT NULL,
  `resolveType` varchar(45) DEFAULT NULL,
  `finishTime` datetime DEFAULT NULL,
  `ariseOrg` int DEFAULT NULL,
  `actualFinish` datetime DEFAULT NULL,
  `completeDesc` varchar(45) DEFAULT NULL,
  `delayReason` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`taskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 108 DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;
UPDATE task_base.task_list
SET completeDesc = '在“迎春杯”和“春雷行动”的活动政策中均有体现。'
WHERE taskId = 108
UPDATE task_base.task_list
SET completeDesc = 'FTTH小区的专项已经制定下发。'
WHERE taskId = 109
UPDATE task_base.task_list
SET completeDesc = '已完成，4月份政企部提供政企全业务素材至市场部。'
WHERE taskId = 110
UPDATE task_base.task_list
SET completeDesc = '已经完成全年宣传计划编制，并在按计划持续进行中。市场运营部围绕全市宣传重点制定了产品宣传计划，目前正在按计划推进，本地电视台、电台、公司自有媒体等渠道均完成了投放，产品知晓度有了一定提升。一季度，部分商业综合体地库、小区门禁广告陆续开始投放，4月份即将开始小区道闸广告的投放，以增强产品宣传的立体化传播效果。但是由于现今信息的分散性，广告宣传效果会有一定滞后。并且，品牌建设是一个长期的过程，我们广告宣传的预算也有额度，投入过大，会对公司的经营产生影响，所以公司及产品的宣传也需要一线人员共同加入，大家一起对公司和产品进行宣传。'
WHERE taskId = 111
UPDATE task_base.task_list
SET completeDesc = '经研究，按照智慧广电乡村工程长效运营要求，第二年，第三年在原有工程基础上有新业态发展及点击率，曝光率有显著增加的地区，参照第一年奖励比例提高。'
WHERE taskId = 112
UPDATE task_base.task_list
SET completeDesc = '陆续推出合约机套餐：针对高端市场，推出苹果常态化合约机套餐；针对农村市场、银发市场，推出一体化合约机套餐；针对各阶层人群，以手机为主，包括各泛终端在内的相关产品，推出安卓常态化合约机套餐。'
WHERE taskId = 113
UPDATE task_base.task_list
SET completeDesc = '企业发展部可牵头协调编制可研中的专业数据等内容。已完成。'
WHERE taskId = 114
UPDATE task_base.task_list
SET completeDesc = '考核指标计分已调整，取消原规模因素系数，原因1.分解指标中已包含人均因素；2.销账奖励中已充分体现大站优势。'
WHERE taskId = 115
UPDATE task_base.task_list
SET completeDesc = '现已经出台千兆宽带政策，并根据省公司的价格体系和对标无锡宽带市场其它运营商价格体系制定了无锡分公司的宽带价格体系。现基本互动用户的宽带主要从100M起，为后期营销已预留出空间。'
WHERE taskId = 116
UPDATE task_base.task_list
SET completeDesc = '高清升级是省政府对于省公司的要求，也是省公司给分公司下达的考核指标，同时也是后期业务发展的基础。'
WHERE taskId = 117
UPDATE task_base.task_list
SET completeDesc = '现有的体验政策都有后续订购策略。'
WHERE taskId = 118
UPDATE task_base.task_list
SET completeDesc = '目前利用各种新媒体手段和渠道制作了各种宣传视频，希望一线同事能积极转发、宣传。'
WHERE taskId = 119
UPDATE task_base.task_list
SET completeDesc = '无锡各镇（街道）与各广电站对口联络，已结合先前及目前对接情况梳理完毕，同时各镇（街道）与多个广电站有交集的，已与各站沟通确定，并已将名单发至各站。后期行政区划调整的，各涉及站协商后作相应调整。'
WHERE taskId = 120
UPDATE `task_base`.`task_list`
SET status = 6
WHERE taskId = 144;
UPDATE `task_base`.`task_list`
SET status = 6
WHERE taskId = 143;
UPDATE `task_base`.`task_list`
SET status = 6
WHERE taskId = 140;
UPDATE `task_base`.`task_list`
SET status = 6
WHERE taskId = 135;
UPDATE `task_base`.`task_list`
SET status = 3
WHERE taskId = 123;
UPDATE `task_base`.`subtask_list`
SET status = 6
WHERE subtaskId = 50;
UPDATE `task_base`.`subtask_list`
SET status = 3
WHERE subtaskId = 51;
UPDATE `task_base`.`subtask_list`
SET status = 3,
  completeDesc = "3月份收集汇总产品素材"
WHERE subtaskId = 53;
UPDATE `task_base`.`subtask_list`
SET status = 3,
  completeDesc = "3月份收集汇总产品素材"
WHERE subtaskId = 53;
ALTER TABLE `task_base`.`task_list`
ADD COLUMN `statusWeight` INT NULL
AFTER `delayTimes`;
ALTER TABLE `task_base`.`subtask_list`
ADD COLUMN `statusWeight` INT NULL
AFTER `delayTimes`;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '召开2023年度智慧广电乡村工程建设推进会，同步开展16个乡镇的调研工作，联合技术部及已建成智慧乡镇广电站讨论确认开机分组方案，明确升级计划并实施'
WHERE subtaskId = 124;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '进行16个智慧广电乡镇（街道）建设，重点推进“一镇一品”乡镇电视平台建设，不断纳入乡镇治理、积分制管理等方面的创新业态，试点推广，增广业务范围'
WHERE subtaskId = 125;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '进行16个智慧广电乡镇（街道）建设，重点推进“一镇一品”乡镇电视平台建设，不断纳入乡镇治理、积分制管理等方面的创新业态，试点推广，增广业务范围'
WHERE subtaskId = 126;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '进行16个智慧广电乡镇（街道）建设，重点推进“一镇一品”乡镇电视平台建设，不断纳入乡镇治理、积分制管理等方面的创新业态，试点推广，增广业务范围'
WHERE subtaskId = 127;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '针对已经建成的智慧广电乡镇（街道），进一步丰富平台内容，加强与其他宣传平台的互融互通，提高点击率，提升覆盖面'
WHERE subtaskId = 129;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '针对已经建成的智慧广电乡镇（街道），进一步丰富平台内容，加强与其他宣传平台的互融互通，提高点击率，提升覆盖面'
WHERE subtaskId = 130;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '针对已经建成的智慧广电乡镇（街道），进一步丰富平台内容，加强与其他宣传平台的互融互通，提高点击率，提升覆盖面'
WHERE subtaskId = 131;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '针对已经建成的智慧广电乡镇（街道），进一步丰富平台内容，加强与其他宣传平台的互融互通，提高点击率，提升覆盖面'
WHERE subtaskId = 132;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '针对已经建成的智慧广电乡镇（街道），进一步丰富平台内容，加强与其他宣传平台的互融互通，提高点击率，提升覆盖面'
WHERE subtaskId = 133;
UPDATE `task_base`.`subtask_list`
SET status = 8
WHERE subtaskId = 155;
INSERT into task_base.user value(
    'dangqun',
    'dangqun123456',
    3,
    'section',
    2,
    '党群工作部'
  );
INSERT into task_base.user value('renli', 'renli123456', 4, 'section', 3, '人力资源部');
INSERT into task_base.user value('caiwu', 'caiwu123456', 5, 'section', 4, '财务资产部');
INSERT into task_base.user value('qyfz', 'qyfz123456', 6, 'section', 5, '企业发展部');
INSERT into task_base.user value(
    'shichang',
    'shichang123456',
    7,
    'section',
    6,
    '市场运营部'
  );
INSERT into task_base.user value(
    'zhengqi',
    'zhengqi123456',
    8,
    'section',
    7,
    '政企客户部'
  );
INSERT into task_base.user value(
    'gongke',
    'gongke123456',
    9,
    'section',
    8,
    '公共客户部'
  );
INSERT into task_base.user value('jszc', 'jszc123456', 10, 'section', 9, '技术支撑部');
INSERT into task_base.user value('gcjs', 'gcjs123456', 11, 'section', 10, '工程建设部');
INSERT into task_base.user value('abyw', 'abyw123456', 12, 'section', 11, '安播运维部');
INSERT INTO `task_base`.`subtask_list`
SET taskGoal = '完成5G业务相关工作的培训、受理流程的规范执行和稽核的监管，5G号卡发展留存6.2万张',
  finishTime = '2023-06-30 00:00:00',
  actualFinish = '2023-06-30 00:00:00',
  status = 4,
  parentId = 20,
  completeDesc = '组织完成5月16日服务促营销培训，6月14日电信运营商服务质量管理培训（一期）。发布《5G移网业务合规操作指导手册》，涉及业务受理场景、业务办理环节、开卡销户、业务稽核、二次认证、相关法律法规等，持续做好5G融合业务相关的服务规范、客户诉求处置管理。6月底5G号卡留存7.23万张。';
INSERT INTO `task_base`.`subtask_list`
SET taskGoal = '完成5G业务受理流程的规范执行、稽核监管，落实相关业务的培训，5G号卡发展留存7.9万张',
  finishTime = '2023-09-30 00:00:00',
  status = 3,
  parentId = 209;
ALTER TABLE `task_base`.`subtask_list` CHANGE COLUMN `completeDesc` `completeDesc` VARCHAR(300) NULL DEFAULT NULL;
UPDATE `task_base`.`subtask_list`
SET finishTime = '2023-11-30 00:00:00'
WHERE subtaskId = 133;
UPDATE `task_base`.`subtask_list`
SET finishTime = '2023-08-31 00:00:00'
where subtaskId = 159;
UPDATE `task_base`.`subtask_list`
SET finishTime = '2023-09-30 00:00:00'
where subtaskId = 160;
UPDATE `task_base`.`subtask_list`
SET finishTime = '2023-10-31 00:00:00'
where subtaskId = 161;
UPDATE `task_base`.`subtask_list`
SET taskGoal = '技术支撑部和工程管理部
3.项目的统一管理，技术、工程前期介入，做好项目的反馈与托底（技术、工程）',
  finishTime = "2023-09-30 00:00:00",
  status = 3
where subtaskId = 68;
UPDATE `task_base`.`task_list`
SET status = 4,
  finishTime = "2023-07-31 00:00:00",
  actualFinish = "2023-07-31 00:00:00",
  taskGoal = "第一阶段 完成5G营业终端升级优化项目的招标采购 完成时间：6月
第二阶段 完成5G营业终端升级优化项目的到货验收 完成时间：7月上旬
第三阶段 完成5G营业终端升级优化项目的安装部署 完成时间：7月下旬",
  completeDesc = '已完成 7月份已完成了全部营业厅终端的更换，目前使用情况正常。'
where taskId = 132;
UPDATE `task_base`.`task_list`
SET status = 3,
  statusWeight = 3
where taskId = 133;
UPDATE `task_base`.`subtask_list`
SET status = 3,
  statusWeight = 3
where subtaskId = 66;
INSERT INTO `task_base`.`subtask_list`
SET finishTime = '2023-11-31 00:00:00',
  taskGoal = '第二阶段 对故障数据异常的器件组织专项处理。完成时间：11月。',
  status = 3,
  parentId = 131;
UPDATE `task_base`.`task_list`
SET taskGoal = '第一阶段 完成5G营业终端升级优化项目的招标采购 完成时间：6月 第二阶段 完成5G营业终端升级优化项目的到货验收 完成时间：7月上旬 第三阶段 完成5G营业终端升级优化项目的安装部署 完成时间：7月下旬'
where taskId = 132;
ALTER TABLE `task_base`.`task_list` CHANGE COLUMN `taskGoal` `taskGoal` VARCHAR(300) NULL DEFAULT NULL;