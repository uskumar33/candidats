<?php

/**
 * CATS
 * Statistics Library
 *
 * Copyright (C) 2005 - 2007 Cognizo Technologies, Inc.
 *
 *
 * The contents of this file are subject to the CATS Public License
 * Version 1.1a (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.catsone.com/.
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * The Original Code is "CATS Standard Edition".
 *
 * The Initial Developer of the Original Code is Cognizo Technologies, Inc.
 * Portions created by the Initial Developer are Copyright (C) 2005 - 2007
 * (or from the year in which this file was created to the year 2007) by
 * Cognizo Technologies, Inc. All Rights Reserved.
 *
 *
 * @package    CATS
 * @subpackage Library
 * @copyright Copyright (C) 2005 - 2007 Cognizo Technologies, Inc.
 * @version    $Id: Statistics.php 3587 2007-11-13 03:55:57Z will $
 */
include_once('./lib/Pipelines.php');

/**
 * 	Statistics Library
 * 	@package    CATS
 * 	@subpackage Library
 */
class Statistics {

    private $_db;
    private $_siteID;
    private $_timeZoneOffset;

    public function __construct($siteID) {
        $this->_siteID = $siteID;
        $this->_db = DatabaseConnection::getInstance();

        // FIXME: Session coupling...
        $this->_timeZoneOffset = $_SESSION['CATS']->getTimeZoneOffset();
    }

    /**
     * Returns the total number of candidates created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getCandidateCount($period) {
        $criterion = $this->makePeriodCriterion('date_created', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS candidate_count
            FROM
                candidate
            WHERE
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['candidate_count'];
    }

    /**
     * 
     * @return type
     */
    public function getReportColumns() {
        //$sql = "select concat_ws(' - ',clientactivityname,clientactivitytype) categories from candidate_joborder where clientactivityname is not null and clientactivitytype is not null order by categories";
        $sql = "select Categories categories from vwRecruitmentSummaryReportColumns";
        $rs = $this->_db->getAllAssoc($sql);

        //return $rs['categories'];
        return $rs;
    }

    /**
     * 
     * @return type
     */
    public function getRecruitmentTrackerColumns() {
        $sql = "select 'Profile Submission Date' AS `categories` union all 
            select 'Initial Screening Result'  union all 
            select 'First Round Date'  union all 
            select 'First Round Result'  union all 
            select 'Second Round Date'  union all 
            select 'Second Round Result'  union all 
            select 'Third Round Date'  union all 
            select 'Third Round Result'  union all 
            select 'Fourth Round Date'  union all 
            select 'Fourth Round Result'  union all 
            select 'Fifth Round Date'  union all 
            select 'Fifth Round Result'  union all 
            select 'Days'  ;
            ";
        $rs = $this->_db->getAllAssoc($sql);

        //return $rs['categories'];
        return $rs;
    }

    public function getInterviewScheduleReportColumns() {
        $sql = "select 'Position Type' AS `categories` union all 
            select 'Current Company'  union all 
            select 'Current Location'  union all 
            select 'Total Exprience'  union all 
            select 'Current CTC'  union all 
            select 'Expected CTC'  union all 
            select 'Notice Period'  union all 
            select 'Contact Number'  union all 
            select 'PAN Number'  union all 
            select 'Skype ID'  union all 
            select 'Current Status'  union all 
            select 'Current Status Description'  union all 
            select 'Interview Date'  ;";
        $rs = $this->_db->getAllAssoc($sql);

        //return $rs['categories'];
        return $rs;
    }

    /**
     * 
     * @return type
     */
    public function getAllCompanies() {
        $sql = "select company_id,name from company order by name";
        $rs = $this->_db->getAllAssoc($sql);
        return $rs;
    }

    /**
     * 
     * @return type
     */
    public function getAllRecruiters() {
        $sql = "select user_id id, user_name name from user where user_id in (select distinct last_modified_by from candidate_joborder) order by user_name";
        $rs = $this->_db->getAllAssoc($sql);
        return $rs;
    }

    /**
     * 
     * @param type $selClientID
     * @param type $selReportColumns
     * @param type $startDate
     * @param type $endDate
     * @param type $selRecruiterID
     * @return type
     */
    public function getRecruitmentSummaryReport($selClientID, $selReportColumns, $startDate, $endDate, $selRecruiterID = -1) {
        $selQueryColumns = "b.title 'Job Title', date(IFNULL(b.start_date,b.date_created)) 'Requisition Date'";
        $selQueryColumnsSummary = "null 'Job Title', 'Totals :'";

        foreach ($selReportColumns as $selReportColumn) {
            if ($selReportColumn == "Profile - Sourced") {
                $selQueryColumns = $selQueryColumns . " ,profile_sourced.cnt 'Profile<br>Sourced'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(profile_sourced.cnt) 'Profile<br>Sourced'";
            }
            if ($selReportColumn == "Profile - Shortlisted") {
                $selQueryColumns = $selQueryColumns . " ,profile_shortlisted.cnt 'Profile<br>Shortlisted'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(profile_shortlisted.cnt) 'Profile<br>Shortlisted'";
            }
            if ($selReportColumn == "Profile - Rejected") {
                $selQueryColumns = $selQueryColumns . " ,profile_rejected.cnt 'Profile<br>Rejected'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(profile_rejected.cnt) 'Profile<br>Rejected'";
            }
            if ($selReportColumn == "Profile - Awaiting Feedback") {
                $selQueryColumns = $selQueryColumns . " ,profile_awaiting_feedback.cnt 'Profile<br>AwaitingFeedback'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(profile_awaiting_feedback.cnt) 'Profile<br>AwaitingFeedback'";
            }
            if ($selReportColumn == "Profile - On Hold") {
                $selQueryColumns = $selQueryColumns . " ,profile_on_hold.cnt 'Profile<br>OnHold'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(profile_on_hold.cnt) 'Profile<br>OnHold'";
            }
            if ($selReportColumn == "Interview - Shortlisted") {
                $selQueryColumns = $selQueryColumns . " ,interview_shortlisted.cnt 'Interview<br>Shortlisted'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_shortlisted.cnt) 'Interview<br>Shortlisted'";
            }
            if ($selReportColumn == "Interview - Scheduled") {
                $selQueryColumns = $selQueryColumns . " ,interview_scheduled.cnt 'Interview<br>Scheduled'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_scheduled.cnt) 'Interview<br>Scheduled'";
            }
            if ($selReportColumn == "Interview - Rescheduled") {
                $selQueryColumns = $selQueryColumns . " ,interview_rescheduled.cnt 'Interview<br>Rescheduled'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_rescheduled.cnt) 'Interview<br>Rescheduled'";
            }
            if ($selReportColumn == "Interview - Rejected") {
                $selQueryColumns = $selQueryColumns . " ,interview_rejected.cnt 'Interview<br>Rejected'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_rejected.cnt) 'Interview<br>Rejected'";
            }
            if ($selReportColumn == "Interview - Awaiting Feedback") {
                $selQueryColumns = $selQueryColumns . " ,interview_awaiting_feedback.cnt 'Interview<br>AwaitingFeedback'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_awaiting_feedback.cnt) 'Interview<br>AwaitingFeedback'";
            }
            if ($selReportColumn == "Interview - On Hold") {
                $selQueryColumns = $selQueryColumns . " ,interview_on_hold.cnt 'Interview<br>OnHold'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(interview_on_hold.cnt) 'Interview<br>OnHold'";
            }
            if ($selReportColumn == "HR - Offered") {
                $selQueryColumns = $selQueryColumns . " ,hr_offered.cnt 'HR<br>offered'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_offered.cnt) 'HR<br>offered'";
            }
            if ($selReportColumn == "HR - Rejected") {
                $selQueryColumns = $selQueryColumns . " ,hr_rejected.cnt 'HR<br>Rejected'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_rejected.cnt) 'HR<br>Rejected'";
            }
            if ($selReportColumn == "HR - Declined") {
                $selQueryColumns = $selQueryColumns . " ,hr_declined.cnt 'HR<br>Declined'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_declined.cnt) 'HR<br>Declined'";
            }
            if ($selReportColumn == "HR - Withdrawn") {
                $selQueryColumns = $selQueryColumns . " ,hr_withdrawn.cnt 'HR<br>Withdrawn'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_withdrawn.cnt) 'HR<br>Withdrawn'";
            }
            if ($selReportColumn == "HR - Joined") {
                $selQueryColumns = $selQueryColumns . " ,hr_joined.cnt 'HR<br>Joined'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_joined.cnt) 'HR<br>Joined'";
            }
            if ($selReportColumn == "HR - On Hold") {
                $selQueryColumns = $selQueryColumns . " ,hr_on_hold.cnt 'HR<br>OnHold'";
                $selQueryColumnsSummary = $selQueryColumnsSummary . " ,sum(hr_on_hold.cnt) 'HR<br>OnHold'";
            }
        }

        $additionalConditions = "";
        if ($selRecruiterID <> -1) {
            $additionalConditions = " last_modified_by = " . $selRecruiterID . " and ";
        }
        $sql = "select " . $selQueryColumns . "  	 
                from company a inner join joborder b on a.company_id = b.company_id 
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Sourced' group by joborder_id) profile_sourced on b.joborder_id=profile_sourced.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Shortlisted' group by joborder_id) profile_shortlisted on b.joborder_id=profile_shortlisted.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Rejected' group by joborder_id) profile_rejected on b.joborder_id=profile_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Awaiting Feedback' group by joborder_id) profile_awaiting_feedback on b.joborder_id=profile_awaiting_feedback.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='On Hold' group by joborder_id) profile_on_hold on b.joborder_id=profile_on_hold.joborder_id 
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Offered' group by joborder_id) hr_offered on b.joborder_id=hr_offered.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Rejected' group by joborder_id) hr_rejected on b.joborder_id=hr_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Declined' group by joborder_id) hr_declined on b.joborder_id=hr_declined.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Withdrawn' group by joborder_id) hr_withdrawn on b.joborder_id=hr_withdrawn.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Joined' group by joborder_id) hr_joined on b.joborder_id=hr_joined.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='On Hold' group by joborder_id) hr_on_hold on b.joborder_id=hr_on_hold.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Shortlisted' group by joborder_id) interview_shortlisted on b.joborder_id=interview_shortlisted.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Scheduled' group by joborder_id) interview_scheduled on b.joborder_id=interview_scheduled.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Rescheduled' group by joborder_id) interview_rescheduled on b.joborder_id=interview_rescheduled.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Rejected' group by joborder_id) interview_rejected on b.joborder_id=interview_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Awaiting Feedback' group by joborder_id) interview_awaiting_feedback on b.joborder_id=interview_awaiting_feedback.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='On Hold' group by joborder_id) interview_on_hold on b.joborder_id=interview_on_hold.joborder_id 
                where 
                    b.status = 'Active' 
                    and a.company_id = " . $selClientID . " 
                    and ((date(b.start_date) between '" . $startDate . "' and '" . $endDate . "') OR (date(b.date_created) between '" . $startDate . "' and '" . $endDate . "'))
                union all
                select " . $selQueryColumnsSummary . "  	 
                from company a inner join joborder b on a.company_id = b.company_id 
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Sourced' group by joborder_id) profile_sourced on b.joborder_id=profile_sourced.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Shortlisted' group by joborder_id) profile_shortlisted on b.joborder_id=profile_shortlisted.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Rejected' group by joborder_id) profile_rejected on b.joborder_id=profile_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='Awaiting Feedback' group by joborder_id) profile_awaiting_feedback on b.joborder_id=profile_awaiting_feedback.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Profile' and clientactivitytype='On Hold' group by joborder_id) profile_on_hold on b.joborder_id=profile_on_hold.joborder_id 
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Offered' group by joborder_id) hr_offered on b.joborder_id=hr_offered.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Rejected' group by joborder_id) hr_rejected on b.joborder_id=hr_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Declined' group by joborder_id) hr_declined on b.joborder_id=hr_declined.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Withdrawn' group by joborder_id) hr_withdrawn on b.joborder_id=hr_withdrawn.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='Joined' group by joborder_id) hr_joined on b.joborder_id=hr_joined.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='HR' and clientactivitytype='On Hold' group by joborder_id) hr_on_hold on b.joborder_id=hr_on_hold.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Shortlisted' group by joborder_id) interview_shortlisted on b.joborder_id=interview_shortlisted.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Scheduled' group by joborder_id) interview_scheduled on b.joborder_id=interview_scheduled.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Rescheduled' group by joborder_id) interview_rescheduled on b.joborder_id=interview_rescheduled.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Interview Rejected' group by joborder_id) interview_rejected on b.joborder_id=interview_rejected.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='Awaiting Feedback' group by joborder_id) interview_awaiting_feedback on b.joborder_id=interview_awaiting_feedback.joborder_id
                        left join (select joborder_id, count(*) cnt from candidate_joborder where " . $additionalConditions . " clientactivityname='Interview' and clientactivitytype='On Hold' group by joborder_id) interview_on_hold on b.joborder_id=interview_on_hold.joborder_id 
                where 
                    b.status = 'Active' 
                    and a.company_id = " . $selClientID . " 
                    and ((date(b.start_date) between '" . $startDate . "' and '" . $endDate . "') OR (date(b.date_created) between '" . $startDate . "' and '" . $endDate . "'))";


        $rs = $this->_db->getAllAssoc($sql);
        return $rs;
    }

    /**
     * 
     * @param type $selReportColumns
     * @param type $startDate
     * @param type $endDate
     * @param type $selRecruiterID
     * @return type
     */
    public function getRecruiterSummaryReport($selReportColumns, $startDate, $endDate, $selRecruiterID) {
        $selQueryColumns = "concat_ws(' ',u.first_name,u.last_name) recruitername
                            , concat_ws(' ',c1.first_name,c1.last_name) candidatename, c1.phone_cell phone 
                            , c2.name companyname
                            , j.title ";
        $grpbyQueryColumns = "group by 
                                a.entered_by, concat_ws(' ',u.first_name,u.last_name), 
                                concat_ws(' ',c1.first_name,c1.last_name), c1.phone_cell 
                                , c2.name
                                , j.title ";

        foreach ($selReportColumns as $selReportColumn) {
            if ($selReportColumn == "Profile Submission Date") {
                $selQueryColumns = $selQueryColumns . " ,date(c.date_created) 'Profile<br>Submission<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(c.date_created) ";
            }
            if ($selReportColumn == "Initial Screening Result") {
                $selQueryColumns = $selQueryColumns . " ,c.InitialScreenResult 'Initial<br>Screening<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,c.InitialScreenResult ";
            }
            if ($selReportColumn == "First Round Date") {
                $selQueryColumns = $selQueryColumns . " ,date(d.date_created) 'Interview<br>Round-1<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(d.date_created) ";
            }
            if ($selReportColumn == "First Round Result") {
                $selQueryColumns = $selQueryColumns . " ,d.InitialScreenResult 'Interview<br>Round-1<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,d.InitialScreenResult ";
            }
            if ($selReportColumn == "Second Round Date") {
                $selQueryColumns = $selQueryColumns . " ,date(e.date_created) 'Interview<br>Round-2<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(e.date_created) ";
            }
            if ($selReportColumn == "Second Round Result") {
                $selQueryColumns = $selQueryColumns . " ,e.InitialScreenResult 'Interview<br>Round-2<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,e.InitialScreenResult ";
            }
            if ($selReportColumn == "Third Round Date") {
                $selQueryColumns = $selQueryColumns . " ,date(f.date_created) 'Interview<br>Round-3<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(f.date_created) ";
            }
            if ($selReportColumn == "Third Round Result") {
                $selQueryColumns = $selQueryColumns . " ,f.InitialScreenResult 'Interview<br>Round-3<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,f.InitialScreenResult ";
            }
            if ($selReportColumn == "Fourth Round Date") {
                $selQueryColumns = $selQueryColumns . " ,date(g.date_created) 'Interview<br>Round-4<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(g.date_created) ";
            }
            if ($selReportColumn == "Fourth Round Result") {
                $selQueryColumns = $selQueryColumns . " ,g.InitialScreenResult 'Interview<br>Round-4<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,g.InitialScreenResult ";
            }
            if ($selReportColumn == "Fifth Round Date") {
                $selQueryColumns = $selQueryColumns . " ,date(h.date_created) 'Interview<br>Round-5<br>Date'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,date(h.date_created) ";
            }
            if ($selReportColumn == "Fifth Round Result") {
                $selQueryColumns = $selQueryColumns . " ,h.InitialScreenResult 'Interview<br>Round-5<br>Result'";
                $grpbyQueryColumns = $grpbyQueryColumns . " ,h.InitialScreenResult ";
            }
            if ($selReportColumn == "Days") {
                $selQueryColumns = $selQueryColumns . " , if(h.InitialScreenResult is not null, datediff(h.date_created, b.SubmittedDate),
		if(g.InitialScreenResult is not null, datediff(g.date_created, b.SubmittedDate),
			if(f.InitialScreenResult is not null, datediff(f.date_created, b.SubmittedDate),
				if(e.InitialScreenResult is not null, datediff(e.date_created, b.SubmittedDate),
					if(d.InitialScreenResult is not null, datediff(d.date_created, b.SubmittedDate),datediff(now(), b.SubmittedDate)					
					)
				)
			)
		)
	) 'Total<br>Days'";
                $grpbyQueryColumns = $grpbyQueryColumns . " , if(h.InitialScreenResult is not null, datediff(h.date_created, b.SubmittedDate),
		if(g.InitialScreenResult is not null, datediff(g.date_created, b.SubmittedDate),
			if(f.InitialScreenResult is not null, datediff(f.date_created, b.SubmittedDate),
				if(e.InitialScreenResult is not null, datediff(e.date_created, b.SubmittedDate),
					if(d.InitialScreenResult is not null, datediff(d.date_created, b.SubmittedDate),datediff(now(), b.SubmittedDate)					
					)
				)
			)
		)
	) ";
            }
        }

        /* $additionalConditions = "";
          if ($selRecruiterID <> -1) {
          $additionalConditions = " last_modified_by = " . $selRecruiterID . " and ";
          } */

        $sql = "select " . $selQueryColumns . "  	 
                from 
	activityclient a 
        inner join user u on a.entered_by = u.user_id 
        inner join candidate c1 on a.data_item_id = c1.candidate_id 
	inner join joborder j on a.joborder_id = j.joborder_id 
	inner join company c2 on j.company_id=c2.company_id 
	left join (select entered_by, data_item_id, joborder_id,max(date(date_created)) SubmittedDate from activityclient where joborder_id>0 and activityname='Profile' and activitytype='Sourced' group by entered_by, data_item_id, joborder_id) b on a.entered_by=b.entered_by and a.data_item_id = b.data_item_id and a.joborder_id=b.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Profile' and activitytype in ('Shortlisted', 'Rejected', 'Awaiting Feedback', 'On Hold') and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Profile' and x2.activitytype in ('Shortlisted', 'Rejected', 'Awaiting Feedback', 'On Hold')) group by entered_by, data_item_id, joborder_id) c on a.entered_by=c.entered_by and a.data_item_id = c.data_item_id and a.joborder_id=c.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Interview Round-1' and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Interview Round-1' ) group by entered_by, data_item_id, joborder_id) d on a.entered_by=d.entered_by and a.data_item_id = d.data_item_id and a.joborder_id=d.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Interview Round-2' and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Interview Round-2' ) group by entered_by, data_item_id, joborder_id) e on a.entered_by=e.entered_by and a.data_item_id = e.data_item_id and a.joborder_id=e.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Interview Round-3' and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Interview Round-3' ) group by entered_by, data_item_id, joborder_id) f on a.entered_by=f.entered_by and a.data_item_id = f.data_item_id and a.joborder_id=f.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Interview Round-4' and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Interview Round-4' ) group by entered_by, data_item_id, joborder_id) g on a.entered_by=g.entered_by and a.data_item_id = g.data_item_id and a.joborder_id=g.joborder_id 
	left join (select entered_by, data_item_id, joborder_id,date_created, activitytype InitialScreenResult from activityclient x1 where joborder_id>0 and activityname='Interview Round-5' and date_created = (select max(date_created) from activityclient x2 where x2.entered_by=x1.entered_by and x2.data_item_id=x1.data_item_id and x2.joborder_id=x1.joborder_id and x2.activityname='Interview Round-5' ) group by entered_by, data_item_id, joborder_id) h on a.entered_by=h.entered_by and a.data_item_id = h.data_item_id and a.joborder_id=h.joborder_id 
        where 
            a.joborder_id > 0 and a.entered_by = " . $selRecruiterID . " 
            and ((date(c.date_created) between '" . $startDate . "' and '" . $endDate . "') OR (c.date_created is null))" . $grpbyQueryColumns;

        //echo $sql;

        $rs = $this->_db->getAllAssoc($sql);
        return $rs;
    }

    public function getInterviewScheduleReport($selClientID, $selReportColumns, $startDate, $endDate) {
        $selQueryColumns = "concat_ws(' ',c1.first_name,c1.last_name) 'Candidate<br>Name', j.title 'Position<br>Applied For'";

        foreach ($selReportColumns as $selReportColumn) {
            if ($selReportColumn == "Position Type") {
                $selQueryColumns = $selQueryColumns . " ,j.type 'Position<br>Type'";
            }
            if ($selReportColumn == "Current Company") {
                $selQueryColumns = $selQueryColumns . " , c1.currentemployer 'Current<br>Employer'";
            }
            if ($selReportColumn == "Current Location") {
                $selQueryColumns = $selQueryColumns . " ,c1.currentlocation 'Current<br>Location'";
            }
            if ($selReportColumn == "Total Exprience") {
                $selQueryColumns = $selQueryColumns . " ,c1.totalexp 'Total<br>Exprience'";
            }
            if ($selReportColumn == "Current CTC") {
                $selQueryColumns = $selQueryColumns . " ,c1.currentCTC 'Current<br>CTC'";
            }
            if ($selReportColumn == "Expected CTC") {
                $selQueryColumns = $selQueryColumns . " ,c1.expectedCTC 'Expected<br>CTC'";
            }
            if ($selReportColumn == "Notice Period") {
                $selQueryColumns = $selQueryColumns . " ,c1.noticeperiod 'Notice<br>Period'";
            }
            if ($selReportColumn == "Contact Number") {
                $selQueryColumns = $selQueryColumns . " ,c1.phone_cell 'Contact<br>Number'";
            }
            if ($selReportColumn == "PAN Number") {
                $selQueryColumns = $selQueryColumns . " ,c1.pan 'PAN<br>Number'";
            }
            if ($selReportColumn == "Skype ID") {
                $selQueryColumns = $selQueryColumns . " ,c1.skypeid 'Skype<br>ID'";
            }
            if ($selReportColumn == "Current Status") {
                $selQueryColumns = $selQueryColumns . " ,a.clientactivityname 'Current<br>Status'";
            }
            if ($selReportColumn == "Current Status Description") {
                $selQueryColumns = $selQueryColumns . " ,a.clientactivitytype 'Current<br>Status<br>Description'";
            }
            if ($selReportColumn == "Interview Date") {
                $selQueryColumns = $selQueryColumns . " ,ce.date 'Interview<br>Schedule<br>Date'";
            }
        }


        $sql = "select " . $selQueryColumns . "  	 
                from 
                    candidate_joborder a 
                    inner join candidate c1 on a.candidate_id = c1.candidate_id 
                    inner join joborder j on a.joborder_id = j.joborder_id
                    inner join calendar_event ce on j.joborder_id = ce.joborder_id 
                    inner join company c2 on j.company_id=c2.company_id 
            where 
                a.clientactivityname like '%Interview%' 
                and c2.company_id = " . $selClientID . "  
                and date(ce.date) between '" . $startDate . "' and '" . $endDate . "';";

        $rs = $this->_db->getAllAssoc($sql);
        return $rs;
    }

    /**
     * Returns the total number of submissions created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getSubmissionCount($period) {
        $criterion = $this->makePeriodCriterion('date', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS submissionCount
            FROM
                candidate_joborder_status_history
            WHERE
                status_to = 400
            AND
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['submissionCount'];
    }

    /**
     * Returns the total number of placements in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getPlacementCount($period) {
        $criterion = $this->makePeriodCriterion('date', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS placementCount
            FROM
                candidate_joborder_status_history
            WHERE
                status_to = 800
            AND
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['placementCount'];
    }

    /**
     * Returns the total number of companies created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getCompanyCount($period) {
        $criterion = $this->makePeriodCriterion('date_created', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS company_count
            FROM
                company
            WHERE
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['company_count'];
    }

    /**
     * Returns the total number of contacts created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getContactCount($period) {
        $criterion = $this->makePeriodCriterion('date_created', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS contact_count
            FROM
                contact
            WHERE
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['contact_count'];
    }

    /**
     * Returns the total number of job orders created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getJobOrderCount($period) {
        $criterion = $this->makePeriodCriterion('date_created', $period);

        $sql = sprintf(
                "SELECT
                COUNT(*) AS joborder_count
            FROM
                joborder
            WHERE
                site_id = %s
            %s", $this->_siteID, $criterion
        );
        $rs = $this->_db->getAssoc($sql);

        return $rs['joborder_count'];
    }

    /**
     * Returns all job orders with submissions created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getSubmissionJobOrders($period) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                joborder.joborder_id AS jobOrderID,
                joborder.title AS title,
                joborder.company_id AS companyID,
                SUM(
                    IF(candidate_joborder_status_history.status_to = 400, 1, 0)
                ) AS submittedCount,
                CONCAT(
                    owner_user.first_name, ' ', owner_user.last_name
                ) AS ownerFullName,
                company.name AS companyName
            FROM
                joborder
            LEFT OUTER JOIN candidate_joborder_status_history
                ON candidate_joborder_status_history.joborder_id = joborder.joborder_id
                %s
            LEFT JOIN company
                ON company.company_id = joborder.company_id
            LEFT JOIN user AS owner_user
                ON owner_user.user_id = joborder.owner
            WHERE
                joborder.status IN ('Active', 'OnHold', 'Full', 'Closed')
            AND
                joborder.site_id = %s
            GROUP BY
                jobOrderID
            HAVING
                submittedCount > 0", $criterion, $this->_siteID
        );

        return $this->_db->getAllAssoc($sql);
    }

    /**
     * Returns all submissions for the specified job order created in the
     * given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getSubmissionsByJobOrder($period, $jobOrderID) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                candidate.candidate_id AS candidateID,
                candidate.first_name AS firstName,
                candidate.last_name AS lastName,
                joborder.joborder_id AS jobOrderID,
                joborder.title AS title,
                joborder.company_id AS companyID,
                CONCAT(
                    owner_user.first_name, ' ', owner_user.last_name
                ) AS ownerFullName,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%m-%%d-%%y (%%h:%%i %%p)'
                ) AS dateSubmitted
            FROM
                candidate_joborder_status_history
            LEFT JOIN candidate
                ON candidate.candidate_id = candidate_joborder_status_history.candidate_id
            LEFT JOIN joborder
                ON joborder.joborder_id = candidate_joborder_status_history.joborder_id
            LEFT JOIN company
                ON company.company_id = joborder.company_id
            LEFT JOIN user AS owner_user
                ON owner_user.user_id = candidate.owner
            WHERE
                candidate_joborder_status_history.joborder_id = %s
            AND
                candidate_joborder_status_history.status_to = 400
            %s
            AND
                candidate.site_id = %s
            AND
                joborder.site_id = %s
            AND
                company.site_id = %s
            ORDER BY
                candidate.last_name ASC,
                candidate.first_name ASC", $jobOrderID, $criterion, $this->_siteID, $this->_siteID, $this->_siteID
        );

        return $this->_db->getAllAssoc($sql);
    }

    /**
     * Returns all job orders with placements created in the given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getPlacementsJobOrders($period) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                joborder.joborder_id AS jobOrderID,
                joborder.title AS title,
                joborder.company_id AS companyID,
                SUM(
                    IF(candidate_joborder_status_history.status_to = 800, 1, 0)
                ) AS submittedCount,
                CONCAT(
                    owner_user.first_name, ' ', owner_user.last_name
                ) AS ownerFullName,
                company.name AS companyName
            FROM
                joborder
            LEFT OUTER JOIN candidate_joborder_status_history
                ON candidate_joborder_status_history.joborder_id = joborder.joborder_id
                %s
            LEFT JOIN company
                ON company.company_id = joborder.company_id
            LEFT JOIN user AS owner_user
                ON owner_user.user_id = joborder.owner
            WHERE
                joborder.status IN ('Active', 'OnHold', 'Full', 'Closed')
            AND
                joborder.site_id = %s
            GROUP BY
                jobOrderID
            HAVING
                submittedCount > 0", $criterion, $this->_siteID
        );

        return $this->_db->getAllAssoc($sql);
    }

    /**
     * Returns all placements for the specified job order created in the
     * given period.
     *
     * @param flag statistics period flag
     * @return integer candidate count
     */
    public function getPlacementsByJobOrder($period, $jobOrderID) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                candidate.candidate_id AS candidateID,
                candidate.first_name AS firstName,
                candidate.last_name AS lastName,
                joborder.joborder_id AS jobOrderID,
                joborder.title AS title,
                joborder.company_id AS companyID,
                CONCAT(
                    owner_user.first_name, ' ', owner_user.last_name
                ) AS ownerFullName,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%m-%%d-%%y (%%h:%%i %%p)'
                ) AS dateSubmitted
            FROM
                candidate_joborder_status_history
            LEFT JOIN candidate
                ON candidate.candidate_id = candidate_joborder_status_history.candidate_id
            LEFT JOIN joborder
                ON joborder.joborder_id = candidate_joborder_status_history.joborder_id
            LEFT JOIN company
                ON company.company_id = joborder.company_id
            LEFT JOIN user AS owner_user
                ON owner_user.user_id = candidate.owner
            WHERE
                candidate_joborder_status_history.joborder_id = %s
            AND
                candidate_joborder_status_history.status_to = 800
            %s
            AND
                candidate.site_id = %s
            AND
                joborder.site_id = %s
            AND
                company.site_id = %s
            ORDER BY
                candidate.last_name ASC,
                candidate.first_name ASC", $jobOrderID, $criterion, $this->_siteID, $this->_siteID, $this->_siteID
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getActivitiesByPeriod($period) {
        $criterion = $this->makePeriodCriterion(
                'activity.date_created', $period
        );

        $sql = sprintf(
                "SELECT
                activity.activity_id AS activityID,
                DATE_FORMAT(
                    activity.date_created, '%%m'
                ) AS month,
                DATE_FORMAT(
                    activity.date_created, '%%d'
                ) AS day,
                DATE_FORMAT(
                    activity.date_created, '%%y'
                ) AS year
            FROM
                activity
            WHERE
                activity.site_id = %s
            %s", $this->_siteID, $criterion
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getCandidatesByPeriod($period) {
        $criterion = $this->makePeriodCriterion(
                'candidate.date_created', $period
        );

        $sql = sprintf(
                "SELECT
                candidate.candidate_id AS candidateID,
                DATE_FORMAT(
                    candidate.date_created, '%%m'
                ) AS month,
                DATE_FORMAT(
                    candidate.date_created, '%%d'
                ) AS day,
                DATE_FORMAT(
                    candidate.date_created, '%%y'
                ) AS year
            FROM
                candidate
            WHERE
                candidate.site_id = %s
            %s", $this->_siteID, $criterion
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getJobOrdersByPeriod($period) {
        $criterion = $this->makePeriodCriterion(
                'joborder.date_created', $period
        );

        $sql = sprintf(
                "SELECT
                joborder.joborder_id AS jobOrderID,
                DATE_FORMAT(
                    joborder.date_created, '%%m'
                ) AS month,
                DATE_FORMAT(
                    joborder.date_created, '%%d'
                ) AS day,
                DATE_FORMAT(
                    joborder.date_created, '%%y'
                ) AS year
            FROM
                joborder
            WHERE
                joborder.site_id = %s
            %s", $this->_siteID, $criterion
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getSubmissionsByPeriod($period) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%m'
                ) AS month,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%d'
                ) AS day,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%y'
                ) AS year
            FROM
                candidate_joborder_status_history
            WHERE
                candidate_joborder_status_history.site_id = %s
            AND
                candidate_joborder_status_history.status_to = 400
            %s", $this->_siteID, $criterion
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getPlacementsByPeriod($period) {
        $criterion = $this->makePeriodCriterion(
                'candidate_joborder_status_history.date', $period
        );

        $sql = sprintf(
                "SELECT
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%m'
                ) AS month,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%d'
                ) AS day,
                DATE_FORMAT(
                    candidate_joborder_status_history.date, '%%y'
                ) AS year
            FROM
                candidate_joborder_status_history
            WHERE
                candidate_joborder_status_history.site_id = %s
            AND
                candidate_joborder_status_history.status_to = 800
            %s", $this->_siteID, $criterion
        );

        return $this->_db->getAllAssoc($sql);
    }

    // FIXME: Document me.
    public function getJobOrderReport($jobOrderID) {
        $sql = sprintf(
                "SELECT
                joborder.joborder_id AS jobOrderID,
                joborder.company_id AS companyID,
                company.name AS companyName,
                joborder.client_job_id AS clientJobID,
                joborder.title AS title,
                joborder.city AS city,
                joborder.state AS state,
                CONCAT(
                    recruiter_user.first_name, ' ', recruiter_user.last_name
                ) AS recruiterFullName,
                CONCAT(
                    owner_user.first_name, ' ', owner_user.last_name
                ) AS ownerFullName,
                DATE_FORMAT(
                    joborder.date_created, '%%m-%%d-%%y (%%h:%%i %%p)'
                ) AS dateCreated,
                COUNT(
                    candidate_joborder.joborder_id
                ) AS pipeline,
                (
                    SELECT
                        COUNT(*)
                    FROM
                        candidate_joborder_status_history
                    WHERE
                        joborder_id = %s
                    AND
                        status_to = %s
                    AND
                        site_id = %s
                ) AS submitted,
                (
                    SELECT
                        COUNT(*)
                    FROM
                        candidate_joborder_status_history
                    WHERE
                        joborder_id = %s
                    AND
                        status_to = %s
                    AND
                        site_id = %s
                ) AS pipelinePlaced,
                (
                    SELECT
                        COUNT(*)
                    FROM
                        candidate_joborder_status_history
                    WHERE
                        joborder_id = %s
                    AND
                        status_to = %s
                    AND
                        site_id = %s
                ) AS pipelineInterving
            FROM
                joborder
            LEFT JOIN company
                ON joborder.company_id = company.company_id
            LEFT JOIN user AS recruiter_user
                ON joborder.recruiter = recruiter_user.user_id
            LEFT JOIN user AS owner_user
                ON joborder.owner = owner_user.user_id
            LEFT JOIN user AS entered_by_user
                ON joborder.entered_by = entered_by_user.user_id
            LEFT JOIN candidate_joborder
                ON joborder.joborder_id = candidate_joborder.joborder_id
            WHERE
                joborder.joborder_id = %s
            AND
                joborder.site_id = %s
            GROUP BY
                joborder.joborder_id", $this->_db->makeQueryInteger($jobOrderID), PIPELINE_STATUS_SUBMITTED, $this->_siteID, $this->_db->makeQueryInteger($jobOrderID), PIPELINE_STATUS_PLACED, $this->_siteID, $this->_db->makeQueryInteger($jobOrderID), PIPELINE_STATUS_INTERVIEWING, $this->_siteID, $this->_db->makeQueryInteger($jobOrderID), $this->_siteID
        );

        return $this->_db->getAssoc($sql);
    }

    public function getEEOReport($modePeriod, $modeStatus) {
        switch ($modePeriod) {
            case 'month':
                $periodChriterion = 'AND TO_DAYS(candidate.date_modified) >= TO_DAYS(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))';
                break;

            case 'week':
                $periodChriterion = 'AND TO_DAYS(candidate.date_modified) >= TO_DAYS(DATE_SUB(CURDATE(), INTERVAL 7 DAY))';
                break;

            default:
                $periodChriterion = '';
                break;
        }

        switch ($modeStatus) {
            case 'placed':
                $statusChriterion = 'AND IF(candidate_joborder_status.candidate_joborder_id, 1, 0) = 1';
                $join = 'LEFT JOIN candidate_joborder AS candidate_joborder_status
                            ON candidate_joborder_status.candidate_id = candidate.candidate_id
                            AND candidate_joborder_status.status >= ' . PIPELINE_STATUS_PLACED . '
                            AND candidate_joborder_status.site_id = ' . $this->_siteID . '
                        ';
                break;

            case 'rejected':
                $statusChriterion = 'AND IF(candidate_joborder_status.candidate_joborder_id, 1, 0) = 1';
                $join = 'LEFT JOIN candidate_joborder AS candidate_joborder_status
                            ON candidate_joborder_status.candidate_id = candidate.candidate_id
                            AND candidate_joborder_status.status = ' . PIPELINE_STATUS_NOTINCONSIDERATION . '
                            AND candidate_joborder_status.site_id = ' . $this->_siteID . '
                        ';
                break;

            default:
                $statusChriterion = '';
                $join = '';
                break;
        }

        $chriterion = $periodChriterion . $statusChriterion;

        $sql = sprintf(
                "SELECT
                COUNT(candidate.candidate_id) AS totalCandidates
             FROM   
                candidate
                %s
             WHERE
                candidate.site_id = %s
                %s
            ", $join, $this->_siteID, $chriterion
        );

        $statistics['rsTotalCandidates'] = $this->_db->getAssoc($sql);

        $sql = sprintf(
                "SELECT
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_ethnic_type_id = eeo_ethnic_type.eeo_ethnic_type_id
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidates,
                eeo_ethnic_type.eeo_ethnic_type_id as EEOEthnicTypeID,
                eeo_ethnic_type.type as EEOEthnicType
             FROM   
                eeo_ethnic_type
            ", $join, $this->_siteID, $chriterion
        );

        $statistics['rsEthnicStatistics'] = $this->_db->getAllAssoc($sql);

        $sql = sprintf(
                "SELECT
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_veteran_type_id = eeo_veteran_type.eeo_veteran_type_id
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidates,
                eeo_veteran_type.eeo_veteran_type_id as EEOVeteranTypeID,
                eeo_veteran_type.type as EEOVeteranType
             FROM   
                eeo_veteran_type
            ", $join, $this->_siteID, $chriterion
        );

        $statistics['rsVeteranStatistics'] = $this->_db->getAllAssoc($sql);

        $sql = sprintf(
                "SELECT
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_disability_status = 'Yes'
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidatesDisabled,
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_disability_status = 'No'
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidatesNonDisabled
             FROM   
                candidate
            ", $join, $this->_siteID, $chriterion, $join, $this->_siteID, $chriterion
        );

        $statistics['rsDisabledStatistics'] = $this->_db->getAssoc($sql);

        $sql = sprintf(
                "SELECT
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_gender = 'm'
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidatesMale,
                (
                    SELECT
                        COUNT(candidate.candidate_id)
                    FROM 
                        candidate
                        %s
                    WHERE
                        candidate.eeo_gender = 'f'
                    AND
                        candidate.site_id = %s
                        %s
                ) AS numberOfCandidatesFemale
             FROM   
                candidate
            ", $join, $this->_siteID, $chriterion, $join, $this->_siteID, $chriterion
        );

        $statistics['rsGenderStatistics'] = $this->_db->getAssoc($sql);

        return $statistics;
    }

    /**
     * Returns an array containing the number of candidates currently in each
     * "status" in the pipeline.
     *
     * @return array statistics data
     */
    public function getPipelineData($jobOrderID = -1) {
        $sql = sprintf(
                "SELECT
                COUNT(*) AS totalPipeline,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS noStatus,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) +
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS noContact,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS contacted,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS qualifying,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS submitted,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS interviewing,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS offered,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS passedOn,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS placed,
                SUM(IF(candidate_joborder.status = %s, 1, 0)) AS replied
            FROM
                candidate_joborder
            LEFT JOIN joborder
                ON joborder.joborder_id = candidate_joborder.joborder_id
            WHERE
                candidate_joborder.site_id = %s
            AND
                joborder.status != 'Closed'
            %s", PIPELINE_STATUS_NOSTATUS, PIPELINE_STATUS_NOCONTACT, PIPELINE_STATUS_NOTINCONSIDERATION, PIPELINE_STATUS_CONTACTED, PIPELINE_STATUS_QUALIFYING, PIPELINE_STATUS_SUBMITTED, PIPELINE_STATUS_INTERVIEWING, PIPELINE_STATUS_OFFERED, PIPELINE_STATUS_CLIENTDECLINED, PIPELINE_STATUS_PLACED, PIPELINE_STATUS_CANDIDATE_REPLIED, $this->_siteID, ($jobOrderID != -1 ? "AND candidate_joborder.joborder_id = " . $jobOrderID : "")
        );
        $rs = $this->_db->getAssoc($sql);

        if (empty($rs)) {
            return array(
                'totalPipeline' => 0,
                'noStatus' => 0,
                'noContact' => 0,
                'contacted' => 0,
                'qualifying' => 0,
                'submitted' => 0,
                'interviewing' => 0,
                'offered' => 0,
                'passedOn' => 0,
                'placed' => 0
            );
        }

        return $rs;
    }

    // FIXME: Document me.
    private function makePeriodCriterion($dateField, $period) {
        /* Note: we add a bogus "AND date > '1900-01-01'" condition to the
         * WHERE clause to force MySQL to use an index containing the date
         * column. MySQL can then build the entire result set without scanning
         * any rows.
         */
        $criteria = '';
        switch ($period) {
            case TIME_PERIOD_TODAY:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND DATE(%s) = CURDATE()', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_YESTERDAY:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND DATE(%s) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_THISWEEK:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND YEARWEEK(%s) = YEARWEEK(NOW())', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_LASTWEEK:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND YEARWEEK(%s) = YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 7 DAY))', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_LASTTWOWEEKS:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND (YEARWEEK(%s) = YEARWEEK(NOW()) OR YEARWEEK(%s) = YEARWEEK(NOW() - INTERVAL 7 DAY))', $dateField, $dateField, $dateField
                );
                break;

            case TIME_PERIOD_THISMONTH:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND EXTRACT(YEAR_MONTH FROM %s) = EXTRACT(YEAR_MONTH FROM CURDATE())', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_LASTMONTH:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND EXTRACT(YEAR_MONTH FROM %s) = EXTRACT(YEAR_MONTH FROM DATE_SUB(CURDATE(), INTERVAL 1 MONTH))', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_THISYEAR:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND YEAR(%s) = YEAR(NOW())', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_LASTYEAR:
                $criteria = sprintf(
                        'AND %s > \'1900-01-01\' AND YEAR(%s) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 YEAR))', $dateField, $dateField
                );
                break;

            case TIME_PERIOD_TODATE:
            default:
                return sprintf('AND %s > \'1900-01-01\'', $dateField);
                break;
        }

        if ($this->_timeZoneOffset != 0) {
            $criteria = str_replace('CURDATE()', 'DATE_ADD(CURDATE(), INTERVAL ' . $this->_timeZoneOffset . ' HOUR)', $criteria);
            $criteria = str_replace('NOW()', 'DATE_ADD(NOW(), INTERVAL ' . $this->_timeZoneOffset . ' HOUR)', $criteria);
            $criteria = str_replace($dateField, 'DATE_ADD(' . $dateField . ', INTERVAL ' . $this->_timeZoneOffset . ' HOUR)', $criteria);
        }

        return $criteria;
    }

}

?>
