<?php

include_once('./lib/Statistics.php');
include_once('./lib/DateUtility.php');
include_once('./lib/Candidates.php');
include_once('./lib/CommonErrors.php');
include_once('./lib/tcpdf/tcpdf.php');
include_once('./lib/tcpdf/config/tcpdf_config.php');

class ReportsUI extends UserInterface {
    /**
     * 
     */
    public function __construct() {
        parent::__construct();

        $this->_authenticationRequired = true;
        $this->_moduleDirectory = 'reports';
        $this->_moduleName = 'reports';
        $this->_moduleTabText = 'Reports';
        $this->_subTabs = array(
            'EEO Reports' => CATSUtility::getIndexName() . '?m=reports&amp;a=customizeEEOReport'
        );
    }
    
    public function handleRequest() {
        if (!eval(Hooks::get('REPORTS_HANDLE_REQUEST')))
            return;

        $action = $this->getAction();
        switch ($action) {
            case 'graphView':
                $this->graphView();
                break;

            case 'generateJobOrderReportPDF':
                $this->generateJobOrderReportPDF();
                break;

            case 'showSubmissionReport':
                $this->showSubmissionReport();
                break;

            case 'showPlacementReport':
                $this->showPlacementReport();
                break;

            case 'customizeJobOrderReport':
                $this->customizeJobOrderReport();
                break;

            case 'customizeEEOReport':
                $this->customizeEEOReport();
                break;

            case 'generateEEOReportPreview':
                $this->generateEEOReportPreview();
                break;

            case 'RecruitmentSummaryReport':
                $this->showRecruitmentSummaryReport();
                break;
            case 'RecruitmentSummaryReportPDF':
                $this->showRecruitmentSummaryReportPDF();
                break;

            case 'RecruiterSummaryReport':
                $this->showRecruiterSummaryReport();
                break;

            case 'RecruiterSummaryReportPDF':
                $this->showRecruiterSummaryReportPDF();
                break;

            case 'RecruitmentTrackerReport':
                $this->showRecruiterTrackerReport();
                break;

            case 'RecruitmentTrackerReportPDF':
                $this->showRecruiterTrackerReportPDF();
                break;

            case 'reports':
            default:
                $this->reports();
                break;
        }
    }

    /**
     * 
     */
    private function getRecruitmentSummaryReport() {

        //$clientName = $_POST['clientName'];
    }

    /**
     * 
     * @param type $rptTitle
     * @param type $htmlText
     */
    private function generatePDF($rptTitle, $htmlText) {
        // create new PDF document
        $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator(PDF_CREATOR);
        $pdf->SetAuthor(PDF_AUTHOR);
        $pdf->SetTitle('CATS');
        $pdf->SetSubject('CATS');
        $pdf->SetKeywords('CATS');

        // set default header data
        //$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE . ' 048', PDF_HEADER_STRING);
        // set header and footer fonts
        //$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        //$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
        // set default monospaced font
        //$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
        // set margins
        $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        /*
          // set some language-dependent strings (optional)
          if (@file_exists('./lib/tcpdf/examples/lang/eng.php')) {
          require_once('./lib/tcpdf/examples/lang/eng.php');
          $pdf->setLanguageArray($l);
          } */

        // ---------------------------------------------------------
        // set font
        $pdf->SetFont('helvetica', 'B', 18);

        // add a page
        $pdf->AddPage('L', 'A4');
        $pdf->Write(0, $rptTitle, '', 0, 'L', true, 0, false, false, 0);
        $pdf->SetFont('helvetica', '', 8);
        // -----------------------------------------------------------------------------

        $pdf->writeHTML($htmlText, true, false, false, false, '');
        //Close and output PDF document
        $pdf->Output('reports.pdf', 'I');
    }

    /**
     * 
     * @param string $GridName
     * @param type $dataArray
     * @return string
     */
    public function ConvertArrayToGrid($GridName, $dataArray) {
        if ($GridName != "")
            $GridName = "<p class='note'>" . $GridName . "</p>";

        $output = $GridName . "        
        <div style='width: 925px; height: auto; overflow: auto; position: relative;font-size: 12px;'>
                <table width='925px' align='center' border='5' cellspacing='0' cellpadding='4'>
                    <thead>
                        <tr>";
        foreach ($dataArray as $key => $value) {
            foreach ($value as $key1 => $value1) {
                $output .= "<th align='center'>" . $key1 . "</th>";
                //echo '<a href="' . $value . '">' . $key . '</a>';
            }
            break;
        }

        $output .= "</tr> 
                    </thead>
                    <tbody>";

        $ii = 0;
        foreach ($dataArray as $key => $value) {
            $output .= "<tr>";
            foreach ($value as $key1 => $value1) {
                $output .= "<td align='center'><div style='font-size: 12px;'><span title='" . $value1 . "'>" . $value1 . "</div></td>";
            }
            $output .= "</tr>";
            $ii++;
        }

        $output .= "</tbody>
                </table></div>";

        return $output;
    }

    /**
     * 
     * @param type $dataArray
     * @return type
     */
    public function ConvertArrayToHTMLTable($dataArray) {
        $output = "        
                <table align='center' border='1' cellspacing='0' cellpadding='4'><thead><tr>";
        foreach ($dataArray as $key => $value) {
            foreach ($value as $key1 => $value1) {
                $output .= "<th>" . $key1 . "</th>";
            }
            break;
        }

        $output .= "</tr> </thead><tbody>";
        foreach ($dataArray as $key => $value) {
            $output .= "<tr>";
            foreach ($value as $key1 => $value1) {
                $output .= "<td>" . $value1 . "</td>";
            }
            $output .= "</tr>";
        }
        $output .= "</tbody></table>";
        $output = str_replace("'", '"', $output);
        return $output;
    }

    /**
     * 
     */
    private function showRecruitmentSummaryReport() {
        //post back values
        $rptTitle = "Recruitment Summary Report";
        $selClientName = "";
        $selClientID = "";
        $startDate = "";
        $endDate = "";
        $selReportColumns = array();
        $strSelReportColumns = "";
        $dataGrid = "";
        $statistics = new Statistics(0);

        $rptColumns = $statistics->getReportColumns();
        $cNames = $statistics->getAllCompanies();

        if (isset($_POST['clientName'])) {
            $selReportColumns = $_POST['reportColumns'];
            $strSelReportColumns = implode(",", $selReportColumns);
            $selClientID = $_POST['clientName'];
            $startDate = $_POST['startDate'];
            $endDate = $_POST['endDate'];

            //get selected client name
            foreach ($cNames as $cName) {
                if ($cName['company_id'] == $selClientID) {
                    $selClientName = $cName['name'];
                    break;
                }
            }

            $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
            $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

            $rptTitle = sprintf("%s - Recruitment Summary Report from %s to %s", $selClientName, $startDate, $endDate);
            $gridData = $statistics->getRecruitmentSummaryReport($selClientID, $selReportColumns, $startDate1, $endDate1);
            $dataGrid = $this->ConvertArrayToGrid($rptTitle, $gridData);

            /* if ($_POST["pdf"] == "1") {
              $this->generatePDF($dataGrid);
              } */
        }

        //set postback values to preserve state 
        $this->_template->assign('dataGrid', $dataGrid);
        $this->_template->assign('selClientName', $selClientID);
        $this->_template->assign('selReportColumns', $selReportColumns);
        $this->_template->assign('strSelReportColumns', $strSelReportColumns);
        $this->_template->assign('startDate', $startDate);
        $this->_template->assign('endDate', $endDate);
        $this->_template->assign('cNames', $cNames);
        $this->_template->assign('rptColumns', $rptColumns);

        $this->_template->display('./modules/reports/RecruitmentSummaryReport.tpl');
    }

    /**
     * 
     */
    private function showRecruitmentSummaryReportPDF() {
        //post back values
        $selClientID = isset($_GET[$id = 'client']) ? $_GET[$id] : false;
        $startDate = isset($_GET[$id = 'startdate']) ? $_GET[$id] : false;
        $endDate = isset($_GET[$id = 'enddate']) ? $_GET[$id] : false;
        $strSelReportColumns = isset($_GET[$id = 'reportcolumns']) ? $_GET[$id] : false;
        $selReportColumns = explode(",", $strSelReportColumns);

        $selClientName = "";
        $strSelReportColumns = "";
        $dataGrid = "";
        $statistics = new Statistics(0);
        $rptColumns = $statistics->getReportColumns();
        $cNames = $statistics->getAllCompanies();

        //get selected client name
        foreach ($cNames as $cName) {
            if ($cName['company_id'] == $selClientID) {
                $selClientName = $cName['name'];
                break;
            }
        }

        $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
        $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

        $rptTitle = sprintf("%s - Recruitment Summary Report from %s to %s", $selClientName, $startDate, $endDate);
        $gridData = $statistics->getRecruitmentSummaryReport($selClientID, $selReportColumns, $startDate1, $endDate1);
        $dataGrid = $this->ConvertArrayToHTMLTable($gridData);

        $this->generatePDF($rptTitle, $dataGrid);
    }

    /**
     * 
     */
    private function showRecruiterSummaryReport() {
        //post back values
        $strSelReportColumns = "";
        $selClientName = "";
        $selClientID = "";
        $startDate = "";
        $endDate = "";
        $selReportColumns = array();
        $dataGrid = "";
        $statistics = new Statistics(0);
        $selRecruiterName = "";
        $selRecruiterID = "";

        $rptColumns = $statistics->getReportColumns();
        $cNames = $statistics->getAllCompanies();
        $recruiterNames = $statistics->getAllRecruiters();

        if (isset($_POST['clientName'])) {
            $selReportColumns = $_POST['reportColumns'];
            $strSelReportColumns = implode(",", $selReportColumns);
            $selClientID = $_POST['clientName'];
            $selRecruiterID = $_POST['recruiterName'];
            $startDate = $_POST['startDate'];
            $endDate = $_POST['endDate'];

            //get selected client name
            foreach ($cNames as $cName) {
                if ($cName['company_id'] == $selClientID) {
                    $selClientName = $cName['name'];
                    break;
                }
            }

            //get selected recruiter name
            foreach ($recruiterNames as $cName) {
                if ($cName['id'] == $selRecruiterID) {
                    $selRecruiterName = $cName['name'];
                    break;
                }
            }

            $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
            $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

            $rptTitle = sprintf("%s - Recruiter (%s) Summary Report from %s to %s", $selClientName, $selRecruiterName, $startDate, $endDate);
            $gridData = $statistics->getRecruitmentSummaryReport($selClientID, $selReportColumns, $startDate1, $endDate1, $selRecruiterID);
            $dataGrid = $this->ConvertArrayToGrid($rptTitle, $gridData);

            /* if ($_POST["pdf"] == "1") {
              $this->generatePDF($dataGrid);
              } */
        }

        //set postback values to preserve state 
        $this->_template->assign('dataGrid', $dataGrid);
        $this->_template->assign('selClientName', $selClientID);
        $this->_template->assign('selReportColumns', $selReportColumns);
        $this->_template->assign('strSelReportColumns', $strSelReportColumns);
        $this->_template->assign('startDate', $startDate);
        $this->_template->assign('endDate', $endDate);
        $this->_template->assign('cNames', $cNames);
        $this->_template->assign('selRecruiterName', $selRecruiterID);
        $this->_template->assign('recruiterNames', $recruiterNames);
        $this->_template->assign('rptColumns', $rptColumns);

        $this->_template->display('./modules/reports/RecruiterSummaryReport.tpl');
    }

    /**
     * 
     */
    private function showRecruiterSummaryReportPDF() {
        $selRecruiterID = isset($_GET[$id = 'recruiterid']) ? $_GET[$id] : false;
        $selClientID = isset($_GET[$id = 'client']) ? $_GET[$id] : false;
        $startDate = isset($_GET[$id = 'startdate']) ? $_GET[$id] : false;
        $endDate = isset($_GET[$id = 'enddate']) ? $_GET[$id] : false;
        $strSelReportColumns = isset($_GET[$id = 'reportcolumns']) ? $_GET[$id] : false;
        $selReportColumns = explode(",", $strSelReportColumns);

        $selClientName = "";
        $dataGrid = "";
        $statistics = new Statistics(0);
        $selRecruiterName = "";

        $rptColumns = $statistics->getReportColumns();
        $cNames = $statistics->getAllCompanies();
        $recruiterNames = $statistics->getAllRecruiters();


        //get selected client name
        foreach ($cNames as $cName) {
            if ($cName['company_id'] == $selClientID) {
                $selClientName = $cName['name'];
                break;
            }
        }

        //get selected recruiter name
        foreach ($recruiterNames as $cName) {
            if ($cName['id'] == $selRecruiterID) {
                $selRecruiterName = $cName['name'];
                break;
            }
        }

        $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
        $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

        $rptTitle = sprintf("%s - Recruiter (%s) Summary Report from %s to %s", $selClientName, $selRecruiterName, $startDate, $endDate);
        $gridData = $statistics->getRecruitmentSummaryReport($selClientID, $selReportColumns, $startDate1, $endDate1, $selRecruiterID);
        $dataGrid = $this->ConvertArrayToHTMLTable($gridData);

        $this->generatePDF($rptTitle, $dataGrid);
    }

    /**
     * 
     */
    private function showRecruiterTrackerReport() {
        //post back values
        $strSelReportColumns = "";
        $startDate = "";
        $endDate = "";
        $selReportColumns = array();
        $dataGrid = "";
        $statistics = new Statistics(0);
        $selRecruiterName = "";
        $selRecruiterID = "";

        $rptColumns = $statistics->getRecruitmentTrackerColumns();
        $recruiterNames = $statistics->getAllRecruiters();

        if (isset($_POST['recruiterName'])) {
            $selReportColumns = $_POST['reportColumns'];
            $strSelReportColumns = implode(",", $selReportColumns);
            $selRecruiterID = $_POST['recruiterName'];
            $startDate = $_POST['startDate'];
            $endDate = $_POST['endDate'];

            //get selected recruiter name
            foreach ($recruiterNames as $cName) {
                if ($cName['id'] == $selRecruiterID) {
                    $selRecruiterName = $cName['name'];
                    break;
                }
            }

            $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
            $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

            $rptTitle = sprintf("Recruiter (%s) Tracker Report from %s to %s", $selRecruiterName, $startDate, $endDate);
            $gridData = $statistics->getRecruiterSummaryReport($selReportColumns, $startDate1, $endDate1, $selRecruiterID);
            $dataGrid = $this->ConvertArrayToGrid($rptTitle, $gridData);
        }

        //set postback values to preserve state 
        $this->_template->assign('dataGrid', $dataGrid);
        $this->_template->assign('selReportColumns', $selReportColumns);
        $this->_template->assign('strSelReportColumns', $strSelReportColumns);
        $this->_template->assign('startDate', $startDate);
        $this->_template->assign('endDate', $endDate);
        $this->_template->assign('selRecruiterName', $selRecruiterID);
        $this->_template->assign('recruiterNames', $recruiterNames);
        $this->_template->assign('rptColumns', $rptColumns);

        $this->_template->display('./modules/reports/RecruitmentTrackerReport.tpl');
    }

    /**
     * 
     */
    private function showRecruiterTrackerReportPDF() {
        $selRecruiterID = isset($_GET[$id = 'recruiterid']) ? $_GET[$id] : false;
        $startDate = isset($_GET[$id = 'startdate']) ? $_GET[$id] : false;
        $endDate = isset($_GET[$id = 'enddate']) ? $_GET[$id] : false;
        $strSelReportColumns = isset($_GET[$id = 'reportcolumns']) ? $_GET[$id] : false;
        $selReportColumns = explode(",", $strSelReportColumns);

        $dataGrid = "";
        $statistics = new Statistics(0);
        $selRecruiterName = "";

        $rptColumns = $statistics->getRecruitmentTrackerColumns();
        $recruiterNames = $statistics->getAllRecruiters();

        //get selected recruiter name
        foreach ($recruiterNames as $cName) {
            if ($cName['id'] == $selRecruiterID) {
                $selRecruiterName = $cName['name'];
                break;
            }
        }

        $startDate1 = DateUtility::convert('-', $startDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);
        $endDate1 = DateUtility::convert('-', $endDate, DATE_FORMAT_MMDDYY, DATE_FORMAT_YYYYMMDD);

        $rptTitle = sprintf("Recruiter (%s) Summary Report from %s to %s", $selRecruiterName, $startDate, $endDate);
        $gridData = $statistics->getRecruiterSummaryReport($selReportColumns, $startDate1, $endDate1, $selRecruiterID);
        $dataGrid = $this->ConvertArrayToHTMLTable($gridData);

        $this->generatePDF($rptTitle, $dataGrid);
    }

    /**
     * 
     * @return type
     */
    private function reports() {
        /* Grab an instance of Statistics. */
        $statistics = new Statistics($this->_siteID);

        /* Get company statistics. */
        $statisticsData['totalCompanies'] = $statistics->getCompanyCount(TIME_PERIOD_TODATE);
        $statisticsData['companiesToday'] = $statistics->getCompanyCount(TIME_PERIOD_TODAY);
        $statisticsData['companiesYesterday'] = $statistics->getCompanyCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['companiesThisWeek'] = $statistics->getCompanyCount(TIME_PERIOD_THISWEEK);
        $statisticsData['companiesLastWeek'] = $statistics->getCompanyCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['companiesThisMonth'] = $statistics->getCompanyCount(TIME_PERIOD_THISMONTH);
        $statisticsData['companiesLastMonth'] = $statistics->getCompanyCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['companiesThisYear'] = $statistics->getCompanyCount(TIME_PERIOD_THISYEAR);
        $statisticsData['companiesLastYear'] = $statistics->getCompanyCount(TIME_PERIOD_LASTYEAR);

        /* Get candidate statistics. */
        $statisticsData['totalCandidates'] = $statistics->getCandidateCount(TIME_PERIOD_TODATE);
        $statisticsData['candidatesToday'] = $statistics->getCandidateCount(TIME_PERIOD_TODAY);
        $statisticsData['candidatesYesterday'] = $statistics->getCandidateCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['candidatesThisWeek'] = $statistics->getCandidateCount(TIME_PERIOD_THISWEEK);
        $statisticsData['candidatesLastWeek'] = $statistics->getCandidateCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['candidatesThisMonth'] = $statistics->getCandidateCount(TIME_PERIOD_THISMONTH);
        $statisticsData['candidatesLastMonth'] = $statistics->getCandidateCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['candidatesThisYear'] = $statistics->getCandidateCount(TIME_PERIOD_THISYEAR);
        $statisticsData['candidatesLastYear'] = $statistics->getCandidateCount(TIME_PERIOD_LASTYEAR);

        /* Get submission statistics. */
        $statisticsData['totalSubmissions'] = $statistics->getSubmissionCount(TIME_PERIOD_TODATE);
        $statisticsData['submissionsToday'] = $statistics->getSubmissionCount(TIME_PERIOD_TODAY);
        $statisticsData['submissionsYesterday'] = $statistics->getSubmissionCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['submissionsThisWeek'] = $statistics->getSubmissionCount(TIME_PERIOD_THISWEEK);
        $statisticsData['submissionsLastWeek'] = $statistics->getSubmissionCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['submissionsThisMonth'] = $statistics->getSubmissionCount(TIME_PERIOD_THISMONTH);
        $statisticsData['submissionsLastMonth'] = $statistics->getSubmissionCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['submissionsThisYear'] = $statistics->getSubmissionCount(TIME_PERIOD_THISYEAR);
        $statisticsData['submissionsLastYear'] = $statistics->getSubmissionCount(TIME_PERIOD_LASTYEAR);

        /* Get placement statistics. */
        $statisticsData['totalPlacements'] = $statistics->getPlacementCount(TIME_PERIOD_TODATE);
        $statisticsData['placementsToday'] = $statistics->getPlacementCount(TIME_PERIOD_TODAY);
        $statisticsData['placementsYesterday'] = $statistics->getPlacementCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['placementsThisWeek'] = $statistics->getPlacementCount(TIME_PERIOD_THISWEEK);
        $statisticsData['placementsLastWeek'] = $statistics->getPlacementCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['placementsThisMonth'] = $statistics->getPlacementCount(TIME_PERIOD_THISMONTH);
        $statisticsData['placementsLastMonth'] = $statistics->getPlacementCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['placementsThisYear'] = $statistics->getPlacementCount(TIME_PERIOD_THISYEAR);
        $statisticsData['placementsLastYear'] = $statistics->getPlacementCount(TIME_PERIOD_LASTYEAR);

        /* Get contact statistics. */
        $statisticsData['totalContacts'] = $statistics->getContactCount(TIME_PERIOD_TODATE);
        $statisticsData['contactsToday'] = $statistics->getContactCount(TIME_PERIOD_TODAY);
        $statisticsData['contactsYesterday'] = $statistics->getContactCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['contactsThisWeek'] = $statistics->getContactCount(TIME_PERIOD_THISWEEK);
        $statisticsData['contactsLastWeek'] = $statistics->getContactCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['contactsThisMonth'] = $statistics->getContactCount(TIME_PERIOD_THISMONTH);
        $statisticsData['contactsLastMonth'] = $statistics->getContactCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['contactsThisYear'] = $statistics->getContactCount(TIME_PERIOD_THISYEAR);
        $statisticsData['contactsLastYear'] = $statistics->getContactCount(TIME_PERIOD_LASTYEAR);

        /* Get job order statistics. */
        $statisticsData['totalJobOrders'] = $statistics->getJobOrderCount(TIME_PERIOD_TODATE);
        $statisticsData['jobOrdersToday'] = $statistics->getJobOrderCount(TIME_PERIOD_TODAY);
        $statisticsData['jobOrdersYesterday'] = $statistics->getJobOrderCount(TIME_PERIOD_YESTERDAY);
        $statisticsData['jobOrdersThisWeek'] = $statistics->getJobOrderCount(TIME_PERIOD_THISWEEK);
        $statisticsData['jobOrdersLastWeek'] = $statistics->getJobOrderCount(TIME_PERIOD_LASTWEEK);
        $statisticsData['jobOrdersThisMonth'] = $statistics->getJobOrderCount(TIME_PERIOD_THISMONTH);
        $statisticsData['jobOrdersLastMonth'] = $statistics->getJobOrderCount(TIME_PERIOD_LASTMONTH);
        $statisticsData['jobOrdersThisYear'] = $statistics->getJobOrderCount(TIME_PERIOD_THISYEAR);
        $statisticsData['jobOrdersLastYear'] = $statistics->getJobOrderCount(TIME_PERIOD_LASTYEAR);

        if (!eval(Hooks::get('REPORTS_SHOW')))
            return;

        $this->_template->assign('active', $this);
        $this->_template->assign('statisticsData', $statisticsData);
        $this->_template->display('./modules/reports/Reports.tpl');
    }

    /**
     * 
     * @return type
     */
    private function graphView() {
        if (isset($_GET['theImage'])) {
            $this->_template->assign('theImage', $_GET['theImage']);
        } else {
            $this->_template->assign('theImage', '');
        }

        if (!eval(Hooks::get('REPORTS_GRAPH')))
            return;

        $this->_template->assign('active', $this);
        $this->_template->display('./modules/reports/GraphView.tpl');
    }

    /**
     * 
     * @return type
     */
    private function showSubmissionReport() {
        //FIXME: getTrimmedInput
        if (isset($_GET['period']) && !empty($_GET['period'])) {
            $period = $_GET['period'];
        } else {
            $period = '';
        }


        switch ($period) {
            case 'yesterday':
                $period = TIME_PERIOD_YESTERDAY;
                $reportTitle = 'Yesterday\'s Report';
                break;

            case 'thisWeek':
                $period = TIME_PERIOD_THISWEEK;
                $reportTitle = 'This Week\'s Report';
                break;

            case 'lastWeek':
                $period = TIME_PERIOD_LASTWEEK;
                $reportTitle = 'Last Week\'s Report';
                break;

            case 'thisMonth':
                $period = TIME_PERIOD_THISMONTH;
                $reportTitle = 'This Month\'s Report';
                break;

            case 'lastMonth':
                $period = TIME_PERIOD_LASTMONTH;
                $reportTitle = 'Last Month\'s Report';
                break;

            case 'thisYear':
                $period = TIME_PERIOD_THISYEAR;
                $reportTitle = 'This Year\'s Report';
                break;

            case 'lastYear':
                $period = TIME_PERIOD_LASTYEAR;
                $reportTitle = 'Last Year\'s Report';
                break;

            case 'toDate':
                $period = TIME_PERIOD_TODATE;
                $reportTitle = 'To Date Report';
                break;

            case 'today':
            default:
                $period = TIME_PERIOD_TODAY;
                $reportTitle = 'Today\'s Report';
                break;
        }

        $statistics = new Statistics($this->_siteID);
        $submissionJobOrdersRS = $statistics->getSubmissionJobOrders($period);

        foreach ($submissionJobOrdersRS as $rowIndex => $submissionJobOrdersData) {
            /* Querys inside loops are bad, but I don't think there is any avoiding this. */
            $submissionJobOrdersRS[$rowIndex]['submissionsRS'] = $statistics->getSubmissionsByJobOrder(
                    $period, $submissionJobOrdersData['jobOrderID'], $this->_siteID
            );
        }

        if (!eval(Hooks::get('REPORTS_SHOW_SUBMISSION')))
            return;

        $this->_template->assign('reportTitle', $reportTitle);
        $this->_template->assign('submissionJobOrdersRS', $submissionJobOrdersRS);
        $this->_template->display('./modules/reports/SubmissionReport.tpl');
    }

    /**
     * 
     * @return type
     */
    private function showPlacementReport() {
        //FIXME: getTrimmedInput
        if (isset($_GET['period']) && !empty($_GET['period'])) {
            $period = $_GET['period'];
        } else {
            $period = '';
        }


        switch ($period) {
            case 'yesterday':
                $period = TIME_PERIOD_YESTERDAY;
                $reportTitle = 'Yesterday\'s Report';
                break;

            case 'thisWeek':
                $period = TIME_PERIOD_THISWEEK;
                $reportTitle = 'This Week\'s Report';
                break;

            case 'lastWeek':
                $period = TIME_PERIOD_LASTWEEK;
                $reportTitle = 'Last Week\'s Report';
                break;

            case 'thisMonth':
                $period = TIME_PERIOD_THISMONTH;
                $reportTitle = 'This Month\'s Report';
                break;

            case 'lastMonth':
                $period = TIME_PERIOD_LASTMONTH;
                $reportTitle = 'Last Month\'s Report';
                break;

            case 'thisYear':
                $period = TIME_PERIOD_THISYEAR;
                $reportTitle = 'This Year\'s Report';
                break;

            case 'lastYear':
                $period = TIME_PERIOD_LASTYEAR;
                $reportTitle = 'Last Year\'s Report';
                break;

            case 'toDate':
                $period = TIME_PERIOD_TODATE;
                $reportTitle = 'To Date Report';
                break;

            case 'today':
            default:
                $period = TIME_PERIOD_TODAY;
                $reportTitle = 'Today\'s Report';
                break;
        }

        $statistics = new Statistics($this->_siteID);
        $placementsJobOrdersRS = $statistics->getPlacementsJobOrders($period);

        foreach ($placementsJobOrdersRS as $rowIndex => $placementsJobOrdersData) {
            /* Querys inside loops are bad, but I don't think there is any avoiding this. */
            $placementsJobOrdersRS[$rowIndex]['placementsRS'] = $statistics->getPlacementsByJobOrder(
                    $period, $placementsJobOrdersData['jobOrderID'], $this->_siteID
            );
        }

        if (!eval(Hooks::get('REPORTS_SHOW_SUBMISSION')))
            return;

        $this->_template->assign('reportTitle', $reportTitle);
        $this->_template->assign('placementsJobOrdersRS', $placementsJobOrdersRS);
        $this->_template->display('./modules/reports/PlacedReport.tpl');
    }

    /**
     * 
     */
    private function customizeJobOrderReport() {
        /* Bail out if we don't have a valid candidate ID. */
        if (!$this->isRequiredIDValid('jobOrderID', $_GET)) {
            CommonErrors::fatal(COMMONERROR_BADINDEX, $this, 'Invalid job order ID.');
        }

        $jobOrderID = $_GET['jobOrderID'];

        $siteName = $_SESSION['CATS']->getSiteName();


        $statistics = new Statistics($this->_siteID);
        $data = $statistics->getJobOrderReport($jobOrderID);

        /* Bail out if we got an empty result set. */
        if (empty($data)) {
            CommonErrors::fatal(COMMONERROR_BADINDEX, $this, 'The specified job order ID could not be found.');
        }

        $reportParameters['siteName'] = $siteName;
        $reportParameters['companyName'] = $data['companyName'];
        $reportParameters['jobOrderName'] = $data['title'];
        $reportParameters['accountManager'] = $data['ownerFullName'];
        $reportParameters['recruiter'] = $data['recruiterFullName'];

        $reportParameters['periodLine'] = sprintf(
                '%s - %s', strtok($data['dateCreated'], ' '), DateUtility::getAdjustedDate('m-d-y')
        );

        $reportParameters['dataSet1'] = $data['pipeline'];
        $reportParameters['dataSet2'] = $data['submitted'];
        $reportParameters['dataSet3'] = $data['pipelineInterving'];
        $reportParameters['dataSet4'] = $data['pipelinePlaced'];

        $dataSet = array(
            $reportParameters['dataSet4'],
            $reportParameters['dataSet3'],
            $reportParameters['dataSet2'],
            $reportParameters['dataSet1']
        );

        $this->_template->assign('reportParameters', $reportParameters);
        $this->_template->assign('active', $this);
        $this->_template->assign('subActive', '');
        $this->_template->display('./modules/reports/JobOrderReport.tpl');
    }

    /**
     * 
     */
    private function customizeEEOReport() {
        $this->_template->assign('modePeriod', 'all');
        $this->_template->assign('modeStatus', 'all');
        $this->_template->assign('active', $this);
        $this->_template->assign('subActive', '');
        $this->_template->display('./modules/reports/EEOReport.tpl');
    }

    /**
     * 
     * @return type
     */
    private function generateJobOrderReportPDF() {
        /* E_STRICT doesn't like FPDF. */
        $errorReporting = error_reporting();
        error_reporting($errorReporting & ~ E_STRICT);
        include_once('./lib/fpdf/fpdf.php');
        error_reporting($errorReporting);

        // FIXME: Hook?
        $isASP = $_SESSION['CATS']->isASP();

        $unixName = $_SESSION['CATS']->getUnixName();

        $siteName = $this->getTrimmedInput('siteName', $_GET);
        $companyName = $this->getTrimmedInput('companyName', $_GET);
        $jobOrderName = $this->getTrimmedInput('jobOrderName', $_GET);
        $periodLine = $this->getTrimmedInput('periodLine', $_GET);
        $accountManager = $this->getTrimmedInput('accountManager', $_GET);
        $recruiter = $this->getTrimmedInput('recruiter', $_GET);
        $notes = $this->getTrimmedInput('notes', $_GET);

        if (isset($_GET['dataSet'])) {
            $dataSet = $_GET['dataSet'];
            $dataSet = explode(',', $dataSet);
        } else {
            $dataSet = array(4, 3, 2, 1);
        }


        /* PDF Font Face. */
        // FIXME: Customizable.
        $fontFace = 'Arial';

        $pdf = new FPDF();
        $pdf->AddPage();

        if (!eval(Hooks::get('REPORTS_CUSTOMIZE_JO_REPORT_PRE')))
            return;

        if ($isASP && $unixName == 'cognizo') {
            /* TODO: MAKE THIS CUSTOMIZABLE FOR EVERYONE. */
            $pdf->SetFont($fontFace, 'B', 10);
            $pdf->Image('images/cognizo-logo.jpg', 130, 10, 59, 20);
            $pdf->SetXY(129, 27);
            $pdf->Write(5, 'Information Technology Consulting');
        }

        $pdf->SetXY(25, 35);
        $pdf->SetFont($fontFace, 'BU', 14);
        $pdf->Write(5, "Recruiting Summary Report\n");

        $pdf->SetFont($fontFace, '', 10);
        $pdf->SetX(25);
        $pdf->Write(5, DateUtility::getAdjustedDate('l, F d, Y') . "\n\n\n");

        $pdf->SetFont($fontFace, 'B', 10);
        $pdf->SetX(25);
        $pdf->Write(5, 'Company: ' . $companyName . "\n");

        $pdf->SetFont($fontFace, '', 10);
        $pdf->SetX(25);
        $pdf->Write(5, 'Position: ' . $jobOrderName . "\n\n");

        $pdf->SetFont($fontFace, '', 10);
        $pdf->SetX(25);
        $pdf->Write(5, 'Period: ' . $periodLine . "\n\n");

        $pdf->SetFont($fontFace, '', 10);
        $pdf->SetX(25);
        $pdf->Write(5, 'Account Manager: ' . $accountManager . "\n");

        $pdf->SetFont($fontFace, '', 10);
        $pdf->SetX(25);
        $pdf->Write(5, 'Recruiter: ' . $recruiter . "\n");

        /* Note that the server is not logged in when getting this file from
         * itself.
         */
        // FIXME: Pass session cookie in URL? Use cURL and send a cookie? I
        //        really don't like this... There has to be a way.
        // FIXME: "could not make seekable" - http://demo.catsone.net/index.php?m=graphs&a=jobOrderReportGraph&data=%2C%2C%2C
        //        in /usr/local/www/catsone.net/data/lib/fpdf/fpdf.php on line 1500
        $URI = CATSUtility::getAbsoluteURI(
                        CATSUtility::getIndexName()
                        . '?m=graphs&a=jobOrderReportGraph&data='
                        . urlencode(implode(',', $dataSet))
        );

        $pdf->Image($URI, 70, 95, 80, 80, 'jpg');

        $pdf->SetXY(25, 180);
        $pdf->SetFont($fontFace, '', 10);
        $pdf->Write(5, 'Total Candidates ');
        $pdf->SetTextColor(255, 0, 0);
        $pdf->Write(5, 'Screened');
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Write(5, ' by ' . $siteName . ": \n\n");

        $pdf->SetX(25);
        $pdf->SetFont($fontFace, '', 10);
        $pdf->Write(5, 'Total Candidates ');
        $pdf->SetTextColor(0, 125, 0);
        $pdf->Write(5, 'Submitted');
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Write(5, ' to ' . $companyName . ": \n\n");

        $pdf->SetX(25);
        $pdf->SetFont($fontFace, '', 10);
        $pdf->Write(5, 'Total Candidates ');
        $pdf->SetTextColor(0, 0, 255);
        $pdf->Write(5, 'Interviewed');
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Write(5, ' by ' . $companyName . ": \n\n");

        $pdf->SetX(25);
        $pdf->SetFont($fontFace, '', 10);
        $pdf->Write(5, 'Total Candidates ');
        $pdf->SetTextColor(255, 75, 0);
        $pdf->Write(5, 'Placed');
        $pdf->SetTextColor(0, 0, 0);
        $pdf->Write(5, ' at ' . $companyName . ": \n\n\n");

        if ($notes != '') {
            $pdf->SetX(25);
            $pdf->SetFont($fontFace, '', 10);
            $pdf->Write(5, "Notes:\n");

            $len = strlen($notes);
            $maxChars = 70;

            $pdf->SetLeftMargin(25);
            $pdf->SetRightMargin(25);
            $pdf->SetX(25);
            $pdf->Write(5, $notes . "\n");
        }

        $pdf->SetXY(165, 180);
        $pdf->SetFont($fontFace, 'B', 10);
        $pdf->Write(5, $dataSet[0] . "\n\n");
        $pdf->SetX(165);
        $pdf->Write(5, $dataSet[1] . "\n\n");
        $pdf->SetX(165);
        $pdf->Write(5, $dataSet[2] . "\n\n");
        $pdf->SetX(165);
        $pdf->Write(5, $dataSet[3] . "\n\n");

        $pdf->Rect(3, 6, 204, 285);

        if (!eval(Hooks::get('REPORTS_CUSTOMIZE_JO_REPORT_POST')))
            return;

        $pdf->Output();
        die();
    }

    /**
     * 
     */
    function generateEEOReportPreview() {
        $modePeriod = $this->getTrimmedInput('period', $_GET);
        $modeStatus = $this->getTrimmedInput('status', $_GET);

        $statistics = new Statistics($this->_siteID);
        $EEOReportStatistics = $statistics->getEEOReport($modePeriod, $modeStatus);

        //print_r($EEOReportStatistics);

        switch ($modePeriod) {
            case 'week':
                $labelPeriod = ' Last Week';
                break;

            case 'month':
                $labelPeriod = ' Last Month';
                break;

            default:
                $labelPeriod = '';
                break;
        }

        switch ($modeStatus) {
            case 'rejected':
                $labelStatus = ' Rejected';
                break;

            case 'placed':
                $labelStatus = ' Placed';
                break;

            default:
                $labelStatus = '';
                break;
        }

        /* Produce the URL to the ethic statistics graph. */
        $labels = array();
        $data = array();

        $rsEthnicStatistics = $EEOReportStatistics['rsEthnicStatistics'];

        foreach ($rsEthnicStatistics as $index => $line) {
            $labels[] = $line['EEOEthnicType'];
            $data[] = $line['numberOfCandidates'];
        }

        $urlEthnicGraph = CATSUtility::getAbsoluteURI(
                        sprintf("%s?m=graphs&a=generic&title=%s&labels=%s&data=%s&width=%s&height=%s", CATSUtility::getIndexName(), urlencode('Number of Candidates' . $labelStatus . ' by Ethnic Type' . $labelPeriod), urlencode(implode(',', $labels)), urlencode(implode(',', $data)), 400, 240
        ));


        /* Produce the URL to the veteran status statistics graph. */
        $labels = array();
        $data = array();

        $rsVeteranStatistics = $EEOReportStatistics['rsVeteranStatistics'];

        foreach ($rsVeteranStatistics as $index => $line) {
            $labels[] = $line['EEOVeteranType'];
            $data[] = $line['numberOfCandidates'];
        }

        $urlVeteranGraph = CATSUtility::getAbsoluteURI(
                        sprintf("%s?m=graphs&a=generic&title=%s&labels=%s&data=%s&width=%s&height=%s", CATSUtility::getIndexName(), urlencode('Number of Candidates' . $labelStatus . ' by Veteran Status' . $labelPeriod), urlencode(implode(',', $labels)), urlencode(implode(',', $data)), 400, 240
        ));

        /* Produce the URL to the gender statistics graph. */
        $labels = array();
        $data = array();

        $rsGenderStatistics = $EEOReportStatistics['rsGenderStatistics'];

        $labels[] = 'Male (' . $rsGenderStatistics['numberOfCandidatesMale'] . ')';
        $data[] = $rsGenderStatistics['numberOfCandidatesMale'];

        $labels[] = 'Female (' . $rsGenderStatistics['numberOfCandidatesFemale'] . ')';
        $data[] = $rsGenderStatistics['numberOfCandidatesFemale'];

        $urlGenderGraph = CATSUtility::getAbsoluteURI(
                        sprintf("%s?m=graphs&a=genericPie&title=%s&labels=%s&data=%s&width=%s&height=%s&legendOffset=%s", CATSUtility::getIndexName(), urlencode('Number of Candidates by Gender'), urlencode(implode(',', $labels)), urlencode(implode(',', $data)), 320, 300, 1.575
        ));

        if ($rsGenderStatistics['numberOfCandidatesMale'] == 0 && $rsGenderStatistics['numberOfCandidatesFemale'] == 0) {
            $urlGenderGraph = "images/noDataByGender.png";
        }

        /* Produce the URL to the disability statistics graph. */
        $labels = array();
        $data = array();

        $rsDisabledStatistics = $EEOReportStatistics['rsDisabledStatistics'];

        $labels[] = 'Disabled (' . $rsDisabledStatistics['numberOfCandidatesDisabled'] . ')';
        $data[] = $rsDisabledStatistics['numberOfCandidatesDisabled'];

        $labels[] = 'Non Disabled (' . $rsDisabledStatistics['numberOfCandidatesNonDisabled'] . ')';
        $data[] = $rsDisabledStatistics['numberOfCandidatesNonDisabled'];

        $urlDisabilityGraph = CATSUtility::getAbsoluteURI(
                        sprintf("%s?m=graphs&a=genericPie&title=%s&labels=%s&data=%s&width=%s&height=%s&legendOffset=%s", CATSUtility::getIndexName(), urlencode('Number of Candidates by Disability Status'), urlencode(implode(',', $labels)), urlencode(implode(',', $data)), 320, 300, 1.575
        ));

        if ($rsDisabledStatistics['numberOfCandidatesNonDisabled'] == 0 && $rsDisabledStatistics['numberOfCandidatesDisabled'] == 0) {
            $urlDisabilityGraph = "images/noDataByDisability.png";
        }

        $EEOSettings = new EEOSettings($this->_siteID);
        $EEOSettingsRS = $EEOSettings->getAll();

        $this->_template->assign('EEOReportStatistics', $EEOReportStatistics);
        $this->_template->assign('urlEthnicGraph', $urlEthnicGraph);
        $this->_template->assign('urlVeteranGraph', $urlVeteranGraph);
        $this->_template->assign('urlGenderGraph', $urlGenderGraph);
        $this->_template->assign('urlDisabilityGraph', $urlDisabilityGraph);
        $this->_template->assign('modePeriod', $modePeriod);
        $this->_template->assign('modeStatus', $modeStatus);
        $this->_template->assign('EEOSettingsRS', $EEOSettingsRS);
        $this->_template->assign('active', $this);
        $this->_template->assign('subActive', '');
        $this->_template->display('./modules/reports/EEOReport.tpl');
    }

}

?>
