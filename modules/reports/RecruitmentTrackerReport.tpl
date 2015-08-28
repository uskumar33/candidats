<?php /* $Id: EEOReport.tpl 2441 2007-05-04 20:42:02Z brian $ */ ?>
<?php TemplateUtility::printHeader('Recruitment Tracker Report', array('modules/joborders/validator.js', 'js/company.js', 'js/sweetTitles.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <table>
            <tr>
                <td width="3%">
                    <img src="images/job_orders.gif" width="24" height="24" border="0" alt="Job Orders" style="margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Recruitment Tracker Report</h2></td>
            </tr>
        </table>


        <?php $URI = CATSUtility::getIndexName() . '?m=reports&amp;a=RecruitmentTrackerReport'; ?>
        <form name="RecruitmentTrackerReportForm" id="RecruitmentTrackerReportForm" action="<?php echo($URI); ?>" method="post" autocomplete="off" enctype="multipart/form-data">
            <table class="editTable" width="450">
                <tr id="visibleTR" >                   
                    <td >
                        <label id="lblReportColumns" for="lblReportColumns">Report Columns :</label><br>
                        <select id="s4" name="reportColumns[]" multiple="reportColumns" size="6" >
                            <?php                             
                            foreach ($this->rptColumns as $rowIndex => $rptColumn) {
                            $cSel = '';
                            foreach ($this->selReportColumns as $selReportColumn) {
                            if ($rptColumn['categories'] == $selReportColumn) {
                            $cSel = 'selected';
                            break;
                            }
                            }
                            ?>
                            <option <?php echo $cSel; ?> value="<?php echo $rptColumn['categories'] ?>"><?php echo $rptColumn['categories'] ?></option>
                            <?php } ?>
                        </select>
                    </td>     
                    <td class="tdVertical">
                        <table class="editTable"  width="250">
                            <tr>
                                <td>
                                    <label id="lblrecruiterName" for="lblrecruiterName">Recruiter Name :</label><br>
                                    <select id="recruiterName" name="recruiterName"   >
                                        <option selected value='-1'>--Select Recruiter--</option>
                                        <?php 
                                        foreach ($this->recruiterNames as $rowIndex => $recruiterName) {                                        
                                        ?>                                        
                                        <option <?php if ($this->selRecruiterName == $recruiterName['id']) echo ' selected'; ?> value="<?php echo $recruiterName['id'] ?>"><?php echo $recruiterName['name'] ?></option>
                                        <?php } ?>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br>
                                    <input type="submit"  class="button" value="Generate Report" />&nbsp;&nbsp;&nbsp;
                                </td>
                            </tr>

                        </table>
                    </td>      
                    <td class="tdVertical">
                        <table class="editTable"  width="250">

                            <tr>
                                <td>
                                    <label id="lblStartDate" for="regardingID">Start Date :</label><br>
                                    <?php if (!empty($this->startDate)): ?>
                                    <script type="text/javascript">DateInput('startDate', false, 'MM-DD-YYYY', '<?php echo($this->startDate); ?>', 9);</script>
                                    <?php else: ?>
                                    <script type="text/javascript">DateInput('startDate', false, 'MM-DD-YYYY', '', 9);</script>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="lblEndDate" for="regardingID">End Date :</label><br>
                                    <?php if (!empty($this->endDate)): ?>
                                    <script type="text/javascript">DateInput('endDate', false, 'MM-DD-YYYY', '<?php echo($this->endDate); ?>', 9);</script>
                                    <?php else: ?>
                                    <script type="text/javascript">DateInput('endDate', false, 'MM-DD-YYYY', '', 9);</script>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        </table>
                    </td>       
                </tr>
            </table>

            <table>
                <tr >                   
                    <td>
                        <?php if (!empty($this->selRecruiterName)){ ?>
                        <?php echo $this->dataGrid; ?>
                        <a target="_blank" href="<?php echo(CATSUtility::getIndexName()); ?>?m=reports&amp;a=RecruitmentTrackerReportPDF&amp;recruiterid=<?php echo($this->selRecruiterName); ?>&amp;reportcolumns=<?php echo($this->strSelReportColumns); ?>&amp;startdate=<?php echo($this->startDate); ?>&amp;enddate=<?php echo($this->endDate); ?>">
                            <img src="images/resume_preview_inline.gif" width="16" height="16" class="absmiddle" alt="GeneratePDF" border="0" />&nbsp;Generate PDF
                        </a>  
                        <?php } else { echo "<h1>Choose report filters...!</h1>"; } ?>
                    </td>
                </tr>
            </table>

        </form>           
    </div>
</div>
<div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
