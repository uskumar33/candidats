<?php /* $Id: Add.tpl 3810 2007-12-05 19:13:25Z brian $ */ ?>
<?php TemplateUtility::printHeader('Job Orders', array('modules/joborders/validator.js',  'js/company.js', 'js/sweetTitles.js', 'js/suggest.js', 'js/joborder.js', 'js/lib.js', 'js/listEditor.js', 'tinymce')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active, $this->subActive); ?>
<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <table>
            <tr>
                <td width="3%">
                    <img src="images/job_orders.gif" width="24" height="24" border="0" alt="Job Orders" style="margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Job Orders: Add Job Order</h2></td>
            </tr>
        </table>

        <p class="note">Add a new job order to the system.</p>

        <?php if ($this->noCompanies): ?>
        <table style="margin-top: 8px; width: 50%;" class="selectView">
            <tr>
                <td>
                    <span><span class="bold">You have not added any companies yet.</span> You can't add a job order until
                        you add at least one company. Please go to the <a href="<?php echo(CATSUtility::getIndexName()); ?>?m=companies">Companies</a>
                        module and add a company.</span>
                </td>
            </tr>
        </table>
        <?php else: ?>
        <form name="addJobOrderForm" id="addJobOrderForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=add" method="post" onsubmit="return checkAddForm(document.addJobOrderForm);" autocomplete="off">
            <input type="hidden" name="postback" id="postback" value="postback" />

            <table class="editTable" width="700">
                <tr>
                    <td class="tdVertical">
                        <label id="titleLabel" for="title">Title:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="1" class="inputbox" id="title" name="title" style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['title'])): ?>value="<?php $this->_($this->jobOrderSourceRS['title']); ?>"<?php endif; ?> />&nbsp;*
                    </td>
                    <!--
                                        <td class="tdVertical">
                                            <label id="startDateLabel" for="startDate">Start Date:</label>
                                        </td>
                                        <td class="tdData">
                                            <script type="text/javascript">DateInput('startDate', false, 'MM-DD-YY', '', 8);</script>
                                        </td>
                    -->
                    <td class="tdVertical">
                        <label id="typeLabel" for="type">Job Type:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="7" id="type" name="type" class="inputbox" style="width: 150px;">
                            <option value="H"   <?php if(isset($this->jobOrderSourceRS['type']) && $this->jobOrderSourceRS['type'] == 'H') echo('selected'); ?>>H (Hire)</option>
                            <option value="C2H" <?php if(isset($this->jobOrderSourceRS['type']) && $this->jobOrderSourceRS['type'] == 'C2H') echo('selected'); ?>>C2H (Contract to Hire)</option>
                            <option value="C"   <?php if(isset($this->jobOrderSourceRS['type']) && $this->jobOrderSourceRS['type'] == 'C') echo('selected'); ?>>C (Contract)</option>
                            <option value="FL"  <?php if(isset($this->jobOrderSourceRS['type']) && $this->jobOrderSourceRS['type'] == 'FL') echo('selected'); ?>>FL (Freelance)</option>
                        </select>&nbsp;*
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="companyIDLabel" for="companyID">Company:</label>
                    </td>

                    <td class="tdData">
                        <input type="hidden" name="companyID" id="companyID" value="<?php if ($this->selectedCompanyID === false) { if (isset($this->jobOrderSourceRS['companyID'])) { echo ($this->jobOrderSourceRS['companyID']); } else { echo(0); } } else { echo($this->selectedCompanyID); } ?>" />

                        <?php if ($this->defaultCompanyID !== false): ?>
                        <input type="radio" name="typeCompany" checked onchange="document.getElementById('companyName').disabled = false; if (oldCompanyID != - 1) document.getElementById('companyID').value = oldCompanyID;">
                        <input type="text" name="companyName" id="companyName" tabindex="2" value="<?php if ($this->selectedCompanyID !== false) { $this->_($this->companyRS['name']); } ?><?php if(isset($this->jobOrderSourceRS['companyName']) && $this->selectedCompanyID == false ): ?><?php $this->_($this->jobOrderSourceRS['companyName']); ?><?php endif; ?>" class="inputbox" style="width: 125px" onFocus="suggestListActivate('getCompanyNames', 'companyName', 'CompanyResults', 'companyID', 'ajaxTextEntryHover', 0, '<?php echo($this->sessionCookie); ?>', 'helpShim');" <?php if ($this->selectedCompanyID !== false) { echo('disabled'); } ?>/>&nbsp;*
                               <?php else: ?>
                               <input type="text" name="companyName" id="companyName" tabindex="2" value="<?php if ($this->selectedCompanyID !== false) { $this->_($this->companyRS['name']); } ?><?php if(isset($this->jobOrderSourceRS['companyName']) && $this->selectedCompanyID == false ): ?><?php $this->_($this->jobOrderSourceRS['companyName']); ?><?php endif; ?>" class="inputbox" style="width: 150px" onFocus="suggestListActivate('getCompanyNames', 'companyName', 'CompanyResults', 'companyID', 'ajaxTextEntryHover', 0, '<?php echo($this->sessionCookie); ?>', 'helpShim');" <?php if ($this->selectedCompanyID !== false) { echo('disabled'); } ?>/>&nbsp;*
                               <?php endif; ?>
                               <br />
                        <iframe id="helpShim" src="javascript:void(0);" scrolling="no" frameborder="0" style="position:absolute; display:none;"></iframe>
                        <div id="CompanyResults" class="ajaxSearchResults"></div>

                        <?php if ($this->defaultCompanyID !== false): ?>
                        <input type="radio" name="typeCompany" id="defaultCompany" onchange="if (document.getElementById('companyName').disabled == false && document.getElementById('companyID').value > 0) {oldCompanyID = document.getElementById('companyID').value; } else if (document.getElementById('companyName').disabled == false) { oldCompanyID = 0; } document.getElementById('companyName').disabled = true; document.getElementById('companyID').value = '<?php echo($this->defaultCompanyID); ?>';">&nbsp;Internal Posting<br />
                        <?php endif; ?>

                        <script type="text/javascript">oldCompanyID = - 1; watchCompanyIDChangeJO('<?php echo($this->sessionCookie); ?>');</script>
                    </td>
                    <td class="tdVertical">
                        <label id="durationLabel" for="duration">CTC Range(in Lakhs):</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="3" id="ctcStartID" name="ctcStart" class="inputbox" style="width: 50px;">
                            <option value="0">0</option>
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="30">30</option>
                            <option value="40">40</option>
                            <option value="50">50</option>
                            <option value="60">60</option>
                            <option value="70">70</option>
                            <option value="80">80</option>
                            <option value="90">90</option>
                        </select>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To :  
                        <select tabindex="3" id="ctcEndID" name="ctcEnd" class="inputbox" style="width: 50px;">
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="30">30</option>
                            <option value="40">40</option>
                            <option value="50">50</option>
                            <option value="60">60</option>
                            <option value="70">70</option>
                            <option value="80">80</option>
                            <option value="90">90</option>
                            <option value="100">100</option>
                        </select>
                    </td>
                    <!--
                                        <td class="tdVertical">
                                            <label id="durationLabel" for="duration">Duration:</label>
                                        </td>
                                        <td class="tdData">
                                            <input type="text" tabindex="11" class="inputbox" id="duration" name="duration" style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['duration'])): ?>value="<?php $this->_($this->jobOrderSourceRS['duration']); ?>"<?php endif; ?> />
                                        </td>
                    -->
                </tr>    
                <!--
                <tr>
                    <td class="tdVertical">
                        <label id="departmentLabel" for="department">Department:</label>

                    </td>
                    <td class="tdData">
                        <select id="departmentSelect" name="department" class="inputbox" style="width: 150px;" onchange="if (this.value == 'edit') { listEditor('Departments', 'departmentSelect', 'departmentsCSV', false); this.value = '(none)'; } if (this.value == 'nullline') { this.value = '(none)'; }">
                            <option value="(none)" selected="selected">None</option>
                        </select>
                        <input type="hidden" id="departmentsCSV" name="departmentsCSV" value="<?php if ($this->selectedCompanyID !== false): $this->_($this->selectedDepartmentsString); endif; ?>" />
                        <?php if ($this->selectedCompanyID !== false): ?>
                        <script type="text/javascript">listEditorUpdateSelectFromCSV('departmentSelect', 'departmentsCSV', true, false);</script>
                        <?php endif; ?>
                    </td>
                    <td class="tdVertical">
                        <label id="maxRateLabel" for="maxRate">Maximum Rate:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="12" class="inputbox" id="maxRate" name="maxRate" style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['maxRate'])): ?>value="<?php $this->_($this->jobOrderSourceRS['maxRate']); ?>"<?php endif; ?>/>
                    </td>
                </tr>
                -->
                <tr>
                    <td class="tdVertical">
                        <label id="contactIDLabel" for="contactID">Contact:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="3" id="contactID" name="contactID" class="inputbox" style="width: 150px;">
                            <option value="-1">None</option>

                            <?php if ($this->selectedCompanyID !== false): ?>
                            <?php foreach ($this->selectedCompanyContacts as $rowNumber => $contactsData): ?>
                            <option value="<?php $this->_($contactsData['contactID']) ?>"><?php $this->_($contactsData['lastName']) ?>, <?php $this->_($contactsData['firstName']) ?></option>
                            <?php endforeach; ?>
                            <?php endif; ?>
                        </select>&nbsp;
                        <img src="images/indicator2.gif" id="contactsIndicator" alt="" style="visibility: hidden; margin-left: 5px;" height="16" width="16" />
                    </td>

                    <td class="tdVertical">
                        <label id="openingsIDLabel" for="openingsID">Openings:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="3" id="openingsID" name="openings" class="inputbox" style="width: 100px;">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="cityLabel" for="city">City:</label>
                    </td>
                    <td class="tdData">
                        <?php if ($this->selectedCompanyID !== false): ?>
                        <input type="text" tabindex="4" class="inputbox" id="city" name="city" value="<?php $this->_($this->selectedCompanyLocation['city']); ?>" style="width: 150px;" />&nbsp;*
                        <?php else: ?>
                        <input type="text" tabindex="4" class="inputbox" id="city" name="city" style="width: 150px;" />&nbsp;*
                        <?php endif; ?>
                    </td>

                    <td class="tdVertical">
                        <label id="salaryLabel" for="salary">Notice Period:</label>
                    </td>
                    <td class="tdData">

                        <select tabindex="3" id="noticeperiodID" name="noticeperiod" class="inputbox" style="width: 100px;">
                            <option value="0">-None-</option>
                            <option value="1">1 Month</option>
                            <option value="2">2 Months</option>
                            <option value="3">3 Months</option>
                            <option value="4">4 Months</option>
                            <option value="5">5 Months</option>
                            <option value="6">6 Months</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="stateLabel" for="state">State:</label>
                    </td>
                    <td class="tdData">
                        <?php if ($this->selectedCompanyID !== false): ?>
                        <input type="text" tabindex="5" class="inputbox" id="state" name="state" value="<?php $this->_($this->selectedCompanyLocation['state']); ?>" style="width: 150px;" />&nbsp;*
                        <?php else: ?>
                        <input type="text" tabindex="5" class="inputbox" id="state" name="state" style="width: 150px;" />&nbsp;*
                        <?php endif; ?>
                    </td>

                    <td class="tdVertical">
                        <label id="clientnameLabel" for="openings">Client Name:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="14" class="inputbox" id="clientnameID" name="clientname" 
                               style="width: 150px;" value="">
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="recruiterLabel" for="recruiter">Recruiter:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="6" id="recruiter" name="recruiter" class="inputbox" style="width: 150px;">
                            <option value="">(Select a User)</option>

                            <?php foreach ($this->usersRS as $rowNumber => $usersData): ?>
                            <?php if ($usersData['userID'] == $this->userID): ?>
                            <option selected value="<?php $this->_($usersData['userID']) ?>"><?php $this->_($usersData['lastName']) ?>, <?php $this->_($usersData['firstName']) ?></option>
                            <?php else: ?>
                            <option value="<?php $this->_($usersData['userID']) ?>"><?php $this->_($usersData['lastName']) ?>, <?php $this->_($usersData['firstName']) ?></option>
                            <?php endif; ?>
                            <?php endforeach; ?>
                        </select>&nbsp;*
                    </td>

                    <td class="tdVertical">
                        <label id="clientnameLabel" for="openings">Client Location:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="14" class="inputbox" id="clientLocationID" name="clientLocation" 
                               style="width: 150px;" value="">
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="ownerLabel" for="owner">Owner:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="6" id="owner" name="owner" class="inputbox" style="width: 150px;">
                            <option value="">(Select a User)</option>

                            <?php foreach ($this->usersRS as $rowNumber => $usersData): ?>
                            <?php if ($usersData['userID'] == $this->userID): ?>
                            <option selected value="<?php $this->_($usersData['userID']) ?>"><?php $this->_($usersData['lastName']) ?>, <?php $this->_($usersData['firstName']) ?></option>
                            <?php else: ?>
                            <option value="<?php $this->_($usersData['userID']) ?>"><?php $this->_($usersData['lastName']) ?>, <?php $this->_($usersData['firstName']) ?></option>
                            <?php endif; ?>
                            <?php endforeach; ?>
                        </select>&nbsp;*
                    </td>
                    <td class="tdVertical">
                        <label id="clientnameLabel" for="openings">Monthly Rate:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="14" class="inputbox" id="monthlyrateID" name="monthlyrate" 
                               style="width: 150px;" value="">
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="isHotLabel" for="isHot">Hot:</label>
                    </td>
                    <td class="tdData">
                        <input type="checkbox" tabindex="16" id="isHot" name="isHot" />&nbsp;
                        <img title="Checking this box indicates that the job order is 'hot', and shows up highlighted throughout the system." src="images/information.gif" alt="" width="16" height="16" />
                    </td>
                    <td class="tdVertical">

                    </td>
                    <td class="tdData">

                    </td>
                </tr>
                <tr>
                    <td class="tdVertical">
                        <label id="publicLabel" for="public">Public:</label>
                    </td>
                    <td class="tdData">
                        <input type="checkbox" tabindex="17" id="public" name="public" onchange="checkPublic(this);" onclick="checkPublic(this);" onkeydown="checkPublic(this);" />&nbsp;
                        <img title="Checking this box indicates that the job order is public. Job orders flaged as public will be able to be viewed by anonymous users." src="images/information.gif" alt="" width="16" height="16" />
                    </td>
                    <td class="tdVertical">

                    </td>
                    <td class="tdData">

                    </td>
                </tr>
            </table>
            <br>
            <p class="note">Candidate Experience</p>

            <table class="editTable" width="700">
                <tr>
                    <td class="tdVertical">
                        <label id="durationLabel" for="duration">Total years of Exp.</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="3" id="expyearsstartID" name="expyearsstart" class="inputbox" style="width: 150px;">
                            <option value="0">0</option>
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="30">30</option>
                            <option value="40">40</option>
                            <option value="50">50</option>
                            <option value="60">60</option>
                            <option value="70">70</option>
                            <option value="80">80</option>
                            <option value="90">90</option>
                        </select>                       
                    </td>
                    <td class="tdVertical">
                        <label id="openingsIDLabel" for="openingsID">To:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="3" id="expyearsendID" name="expyearsend" class="inputbox" style="width: 150px;">
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="30">30</option>
                            <option value="40">40</option>
                            <option value="50">50</option>
                            <option value="60">60</option>
                            <option value="70">70</option>
                            <option value="80">80</option>
                            <option value="90">90</option>
                            <option value="100">100</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" width=250px" class="button" name="btnmandatoryskills"  value="Add mandatory skillset (if any)"  />                        
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 50px;">
                            <table class="editTable" width="500">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill 1</label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="14" class="inputbox" id="clientLocationID" name="clientLocation" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">To:</label>
                                    </td>
                                    <td class="tdData">
                                        <select tabindex="3" id="ctcEndID" name="ctcEnd" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" class="button" name="btnoptionalskills"  value="Add optional skillset (if any)"  />
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 50px;">
                            <table class="editTable" width="500">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill 1</label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="14" class="inputbox" id="clientLocationID" name="clientLocation" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">To:</label>
                                    </td>
                                    <td class="tdData">
                                        <select tabindex="3" id="ctcEndID" name="ctcEnd" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            <p class="note">Certifications</p>
            <table class="editTable" width="700">                
                <tr>
                    <td colspan="4" class="tdVertical">
                        <br>
                        <input type="button" width=250px" class="button" name="btnmandatoryskills"  value="Add Certifications (if any)"  />                        
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 50px;">
                            <table class="editTable" width="500">
                                <tr>
                                    <td class="tdVertical">
                                        <label id="durationLabel" for="duration">Certification 1</label>
                                    </td>
                                    <td class="tdData">
                                        <input type="text" tabindex="14" class="inputbox" id="clientLocationID" name="clientLocation" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">To:</label>
                                    </td>
                                    <td class="tdData">
                                        <select tabindex="3" id="ctcEndID" name="ctcEnd" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>               
            </table>
            <br>
            <table class="editTable" width="700">

                <?php for ($i = 0; $i < count($this->extraFieldRS); $i++): ?>
                <tr>
                    <td class="tdVertical" id="extraFieldTd<?php echo($i); ?>">
                        <label id="extraFieldLbl<?php echo($i); ?>">
                            <?php $this->_($this->extraFieldRS[$i]['fieldName']); ?>:
                        </label>
                    </td>
                    <td class="tdData" id="extraFieldData<?php echo($i); ?>">
                        <?php echo($this->extraFieldRS[$i]['addHTML']); ?>
                    </td>
                </tr>
                <?php endfor; ?>

                <tr>
                    <td class="tdVertical">
                        <label id="descriptionLabel" for="description">Description:</label>
                    </td>
                    <td class="tdData">
                        <textarea tabindex="18" class="mceEditor" name="description" id="description" rows="15" style="width: 500px;"><?php if(isset($this->jobOrderSourceRS['description'])): ?><?php $this->_($this->jobOrderSourceRS['description']); ?><?php endif; ?></textarea>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="notesLabel" for="notes">Internal Notes:</label>
                    </td>
                    <td class="tdData">
                        <textarea tabindex="19" class="mceEditor" name="notes" id="notes" rows="5" style="width: 500px;"><?php if(isset($this->jobOrderSourceRS['notes'])): ?><?php $this->_($this->jobOrderSourceRS['notes']); ?><?php endif; ?></textarea>
                    </td>
                </tr>

                <tr id="displayQuestionnaires" style="display: none;">
                    <?php if ($this->careerPortalEnabled): ?>
                    <td class="tdVertical">
                        <label id="notesLabel" for="notes">Questionnaire:</label>
                    </td>
                    <td class="tdData">
                        <select id="questionnaire" name="questionnaire" class="inputbox" style="width: 500px;">
                            <option value="none" selected>None</option>
                            <?php foreach ($this->questionnaires as $questionnaire): ?>
                            <option value="<?php echo $questionnaire['questionnaireID']; ?>"><?php echo $questionnaire['title']; ?></option>
                            <?php endforeach; ?>
                        </select>
                        <?php if ($_SESSION['CATS']->getAccessLevel() >= ACCESS_LEVEL_SA): ?>
                        <br />
                        <a href="<?php echo CATSUtility::getIndexName(); ?>?m=settings&a=careerPortalSettings" target="_blank">Add / Edit / Delete Questionnaires</a>
                        <?php endif; ?>
                    </td>
                    <?php endif; ?>
                </tr>
            </table>
            <input type="submit" tabindex="20" class="button" name="submit" value="Add Job Order" />&nbsp;
            <input type="reset"  tabindex="21" class="button" name="reset"  value="Reset" />&nbsp;
            <input type="button" tabindex="22" class="button" name="back"   value="Back to Job Orders" onclick="javascript:goToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=listByView');" />
        </form>

        <script type="text/javascript">
                    document.addJobOrderForm.title.focus();
                    < ?php if (isset($this - > jobOrderSourceRS['companyID'])): ? > updateCompanyData('<?php echo($this->sessionCookie); ?>'); < ?php endif; ? >
                    $(document).ready(function () {

            });
        </script>

        <?php endif; ?>
    </div>
</div>
<div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
