<?php /* $Id: EEOReport.tpl 2441 2007-05-04 20:42:02Z brian $ */ ?>
<?php TemplateUtility::printHeader('Recruitment Summary Report', array('modules/joborders/validator.js', 'js/company.js', 'js/sweetTitles.js')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <table>
            <tr>
                <td width="3%">
                    <img src="images/job_orders.gif" width="24" height="24" border="0" alt="Job Orders" style="margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Recruitment Summary Report</h2></td>
            </tr>
        </table>


        <?php $URI = CATSUtility::getIndexName() . '?m=reports&amp;a=RecruitmentSummaryReport'; ?>
        <form name="RecruitmentSummaryReportForm" id="RecruitmentSummaryReportForm" action="<?php echo($URI); ?>" method="post" autocomplete="off" enctype="multipart/form-data">
            <table class="editTable" width="450">
                <tr id="visibleTR" >                   
                    <td >
                        <label id="lblReportColumns" for="lblReportColumns">Report Columns :</label><br>
                        <select id="s4" name="reportColumns[]" multiple="reportColumns" size="8" >
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
                                    <label id="lblClient" for="regardingID">Client :</label><br>
                                    <select id="clientName" name="clientName"   >
                                        <option selected value='-1'>--Select Client--</option>
                                        <?php 
                                        foreach ($this->cNames as $rowIndex => $cName) {                                        
                                        ?>                                        
                                        <option <?php if ($this->selClientName == $cName['company_id']) echo ' selected'; ?> value="<?php echo $cName['company_id'] ?>"><?php echo $cName['name'] ?></option>
                                        <?php } ?>
                                    </select>
                                </td>
                            </tr>
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
                            <tr>
                                <td>
                                    <input type="submit"  class="button" value="Generate Report" />&nbsp;&nbsp;&nbsp;
                                </td>   
                            </tr>
                        </table>
                    </td>       
                </tr>
            </table>

            <table>
                <tr >                   
                    <td>
                        <?php if (!empty($this->selClientName)){ ?>                        
                        <?php echo $this->dataGrid; ?>
                        <a target="_blank" href="<?php echo(CATSUtility::getIndexName()); ?>?m=reports&amp;a=RecruitmentSummaryReportPDF&reportcolumns=<?php echo($this->strSelReportColumns); ?>&amp;client=<?php echo($this->selClientName); ?>&amp;startdate=<?php echo($this->startDate); ?>&amp;enddate=<?php echo($this->endDate); ?>">
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
