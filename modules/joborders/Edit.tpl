<?php /* $Id: Edit.tpl 3810 2007-12-05 19:13:25Z brian $ */ ?>
<?php TemplateUtility::printHeader('Job Orders', array('modules/joborders/validator.js', 'modules/joborders/customjobordersvalidation.js', 'js/company.js', 'js/sweetTitles.js',  'js/suggest.js', 'js/joborder.js', 'js/lib.js', 'js/listEditor.js', 'tinymce')); ?>
<?php TemplateUtility::printHeaderBlock(); ?>
<?php TemplateUtility::printTabs($this->active); ?>
<div id="main">
    <?php TemplateUtility::printQuickSearch(); ?>

    <div id="contents">
        <table>
            <tr>
                <td width="3%">
                    <img src="images/job_orders.gif" width="24" height="24" border="0" alt="Job Orders" style="margin-top: 3px;" />&nbsp;
                </td>
                <td><h2>Job Orders: Edit Job Order</h2></td>
            </tr>
        </table>

        <p class="note">Edit Job Order</p>

        <form name="editJobOrderForm" id="editJobOrderForm" action="<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=edit" method="post" onsubmit="return checkEditForm(document.editJobOrderForm);" autocomplete="off">
            <input type="hidden" name="postback" id="postback" value="postback" />
            <input type="hidden" id="jobOrderID" name="jobOrderID" value="<?php echo($this->jobOrderID); ?>" />

            <table class="editTable" width="700">
                <tr>
                    <td class="tdVertical">
                        <label id="titleLabel" for="title">Title:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="1" class="inputbox" id="title" name="title" style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['title'])): ?>value="<?php $this->_($this->jobOrderSourceRS['title']); ?>"<?php endif; ?> />&nbsp;*
                    </td>
                    <td class="tdVertical">
                        <label id="typeLabel" for="type">Job Type:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="2" id="type" name="type" class="inputbox" onChange="whenJobTypeChange()" style="width: 150px;">
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
                        <input type="radio" tabindex="2" name="typeCompany" checked onchange="document.getElementById('companyName').disabled = false;
                                if (oldCompanyID != -1)
                                    document.getElementById('companyID').value = oldCompanyID;">
                        <input type="text" name="companyName" id="companyName" tabindex="3" value="<?php if ($this->selectedCompanyID !== false) { $this->_($this->companyRS['name']); } ?><?php if(isset($this->jobOrderSourceRS['companyName']) && $this->selectedCompanyID == false ): ?><?php $this->_($this->jobOrderSourceRS['companyName']); ?><?php endif; ?>" class="inputbox" style="width: 125px" onFocus="suggestListActivate('getCompanyNames', 'companyName', 'CompanyResults', 'companyID', 'ajaxTextEntryHover', 0, '<?php echo($this->sessionCookie); ?>', 'helpShim');" <?php if ($this->selectedCompanyID !== false) { echo('disabled'); } ?>/>&nbsp;*
                               <?php else: ?>
                               <input type="text" name="companyName" id="companyName" tabindex="4" value="<?php if ($this->selectedCompanyID !== false) { $this->_($this->companyRS['name']); } ?><?php if(isset($this->jobOrderSourceRS['companyName']) && $this->selectedCompanyID == false ): ?><?php $this->_($this->jobOrderSourceRS['companyName']); ?><?php endif; ?>" class="inputbox" style="width: 150px" onFocus="suggestListActivate('getCompanyNames', 'companyName', 'CompanyResults', 'companyID', 'ajaxTextEntryHover', 0, '<?php echo($this->sessionCookie); ?>', 'helpShim');" <?php if ($this->selectedCompanyID !== false) { echo('disabled'); } ?>/>&nbsp;*
                               <?php endif; ?>
                               <br />
                        <iframe id="helpShim" src="javascript:void(0);" scrolling="no" frameborder="0" style="position:absolute; display:none;"></iframe>
                        <div id="CompanyResults" class="ajaxSearchResults"></div>

                        <?php if ($this->defaultCompanyID !== false): ?>
                        <input type="radio" name="typeCompany" id="defaultCompany" onchange="if (document.getElementById('companyName').disabled == false && document.getElementById('companyID').value > 0) {oldCompanyID = document.getElementById('companyID').value; } else if (document.getElementById('companyName').disabled == false) {
                                    oldCompanyID = 0;
                                }
                                document.getElementById('companyName').disabled = true;
                                document.getElementById('companyID').value = '<?php echo($this->defaultCompanyID); ?>';">&nbsp;Internal Posting<br />
                        <?php endif; ?>

                        <script type="text/javascript">oldCompanyID = -1;
                            watchCompanyIDChangeJO('<?php echo($this->sessionCookie); ?>');</script>
                    </td>
                    <td class="tdVertical">
                        <label id="durationLabel" for="duration">CTC Range(in Lakhs):</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="7" class="inputbox" id="ctcStart" name="ctcStart" 
                               style="width: 150px;" value="">
                    </td>
                </tr> 
                <tr>
                    <td class="tdVertical">
                        <label id="contactIDLabel" for="contactID">Contact:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="7" id="contactID" name="contactID" class="inputbox" style="width: 150px;">
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
                        <select tabindex="8" id="openingsID" name="openings" class="inputbox" style="width: 100px;">
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
                        <input type="text" tabindex="9" class="inputbox" id="city" name="city" value="<?php $this->_($this->selectedCompanyLocation['city']); ?>" style="width: 150px;" />&nbsp;*
                        <?php else: ?>
                        <input type="text" tabindex="9" class="inputbox" id="city" name="city" style="width: 150px;" />&nbsp;*
                        <?php endif; ?>
                    </td>

                    <td class="tdVertical">
                        <label id="salaryLabel" for="salary">Notice Period:</label>
                    </td>
                    <td class="tdData">

                        <select tabindex="10" id="noticeperiod" name="noticeperiod" class="inputbox" style="width: 100px;">
                            <option value="0">-None-</option>
                            <option value="Immediate">Immediate</option>
                            <option value="7 days">7 days</option>
                            <option value="15 days">15 days</option>
                            <option value="30 days">30 days</option>
                            <option value="2 Month">2 Month</option>
                            <option value="3 Month">3 Month</option>
                            <option value="Greater than 3 Month">Greater than 3 Month</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="stateLabel" for="state">State:</label>
                    </td>
                    <td class="tdData">
                        <?php if ($this->selectedCompanyID !== false): ?>
                        <input type="text" tabindex="11" class="inputbox" id="state" name="state" value="<?php $this->_($this->selectedCompanyLocation['state']); ?>" style="width: 150px;" />&nbsp;*
                        <?php else: ?>
                        <input type="text" tabindex="11" class="inputbox" id="state" name="state" style="width: 150px;" />&nbsp;*
                        <?php endif; ?>
                    </td>

                    <td class="tdVertical">
                        <label id="clientnameLabel" for="openings">Client Name:</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="12" class="inputbox" id="clientname" name="clientname" 
                               style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['clientname'])): ?>value="<?php $this->_($this->jobOrderSourceRS['clientname']); ?>"<?php endif; ?>>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="recruiterLabel" for="recruiter">Recruiter:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="13" id="recruiter" name="recruiter" class="inputbox" style="width: 150px;">
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
                        <input type="text" tabindex="14" class="inputbox" id="clientLocation" name="clientLocation" 
                               style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['clientlocation'])): ?>value="<?php $this->_($this->jobOrderSourceRS['clientlocation']); ?>"<?php endif; ?>>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="ownerLabel" for="owner">Owner:</label>
                    </td>
                    <td class="tdData">
                        <select tabindex="15" id="owner" name="owner" class="inputbox" style="width: 150px;">
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
                        <input type="text" tabindex="16" class="inputbox" id="monthlyrate" name="monthlyrate" 
                               style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['clientmonthlyrate'])): ?>value="<?php $this->_($this->jobOrderSourceRS['clientmonthlyrate']); ?>"<?php endif; ?>>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="isHotLabel" for="isHot">Hot:</label>
                    </td>
                    <td class="tdData">
                        <input type="checkbox" tabindex="17" id="isHot" name="isHot" />&nbsp;
                        <img title="Checking this box indicates that the job order is 'hot', and shows up highlighted throughout the system." src="images/information.gif" alt="" width="16" height="16" />
                    </td>

                    <td class="tdVertical">
                        <label id="durationLabel" for="duration">Total years of Exp.</label>
                    </td>
                    <td class="tdData">
                        <input type="text" tabindex="19" class="inputbox" id="expyearsstart" name="expyearsstart" 
                               style="width: 150px;" <?php if(isset($this->jobOrderSourceRS['exprience'])): ?>value="<?php $this->_($this->jobOrderSourceRS['exprience']); ?>"<?php endif; ?>>
                    </td>

                </tr>
                <tr>
                    <td class="tdVertical">
                        <label id="publicLabel" for="public">Public:</label>
                    </td>
                    <td class="tdData">
                        <input type="checkbox" tabindex="18" id="public" name="public" onchange="checkPublic(this);" onclick="checkPublic(this);" onkeydown="checkPublic(this);" />&nbsp;
                        <img title="Checking this box indicates that the job order is public. Job orders flaged as public will be able to be viewed by anonymous users." src="images/information.gif" alt="" width="16" height="16" />
                    </td>
                    <td class="tdVertical">
                        <label id="statusLabel" for="status">Status:</label>
                    </td>
                    <td class="tdData">
                        <?php if(isset($this->overOpenJOQuota) && ($this->jobOrderSourceRS['status'] == 'OnHold' || $this->jobOrderSourceRS['status'] == 'Full' || $this->jobOrderSourceRS['status'] == 'Closed' || $this->jobOrderSourceRS['status'] == 'Canceled')): ?>
                        <select tabindex="8" id="status" name="status" class="inputbox" style="width: 150px;">
                            <option <?php if ($this->jobOrderSourceRS['status'] == 'OnHold'): ?>selected<?php endif; ?> value="OnHold">On Hold</option>
                            <option <?php if ($this->jobOrderSourceRS['status'] == 'Full'): ?>selected<?php endif; ?> value="Full">Full</option>
                            <option <?php if ($this->jobOrderSourceRS['status'] == 'Closed'): ?>selected<?php endif; ?> value="Closed">Closed</option>
                            <option <?php if ($this->jobOrderSourceRS['status'] == 'Canceled'): ?>selected<?php endif; ?> value="Canceled">Canceled</option>
                        </select><br />
                        <span style="font-size:10px;">(You have already reached your limit of <?php echo(FREE_ACCOUNT_JOBORDERS); ?> open Job Orders, and cannot make this Job Order Active.)<br /></font>

                            <?php else: ?>
                            <select tabindex="8" id="status" name="status" class="inputbox" style="width: 150px;">
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Active'): ?>selected<?php endif; ?> value="Active">Active</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Upcoming'): ?>selected<?php endif; ?> value="Upcoming">Upcoming</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Lead'): ?>selected<?php endif; ?> value="Lead">Prospective / Lead</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'OnHold'): ?>selected<?php endif; ?> value="OnHold">On Hold</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Full'): ?>selected<?php endif; ?> value="Full">Full</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Closed'): ?>selected<?php endif; ?> value="Closed">Closed</option>
                                <option <?php if ($this->jobOrderSourceRS['status'] == 'Canceled'): ?>selected<?php endif; ?> value="Canceled">Canceled</option>
                            </select>
                            <?php endif; ?>
                    </td>
                </tr>

            </table>
            <br>
            <p class="note">Candidate Skill Experience - Mandatory</p>
            <table class="editTable" width="700">

                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="650" id="mytab1">
                                <?php if ($this->joborderMandatorySkills !== false): ?>
                                <?php foreach ($this->joborderMandatorySkills as $rowNumber => $contactsData): ?>
                                <tr>
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="21" class="inputbox" id="mandatoryskillname" name="mandatoryskillname[]" 
                                               style="width: 150px;" value="<?php $this->_($contactsData['skillname']) ?>">
                                    </td>
                                    <td width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">Exp.</label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="22" id="mandatoryskillnameexp" name="mandatoryskillnameexp[]" class="inputbox" style="width: 100px;">
                                            <option value="-1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '-1') echo('selected'); ?>>-Select from List-</option>
                                            <option value="1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '1') echo('selected'); ?>><1</option>
                                            <option value="2" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '2') echo('selected'); ?>><2</option>
                                            <option value="3" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '3') echo('selected'); ?>><3</option>
                                            <option value="4" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '4') echo('selected'); ?>><4</option>
                                            <option value="5" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '5') echo('selected'); ?>><5</option>
                                            <option value="6" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '6') echo('selected'); ?>><6</option>
                                            <option value="7" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '7') echo('selected'); ?>><7</option>
                                            <option value="8" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '8') echo('selected'); ?>><8</option>
                                            <option value="9" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '9') echo('selected'); ?>><9</option>
                                            <option value="10" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '10') echo('selected'); ?>><10</option>
                                            <option value="11" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '11') echo('selected'); ?>>>10</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab1addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab1')">
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                                <tr >
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="21" class="inputbox" id="mandatoryskillname" name="mandatoryskillname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">Exp.</label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="22" id="mandatoryskillnameexp" name="mandatoryskillnameexp[]" class="inputbox" style="width: 100px;">
                                            <option value="-1">-Select from List-</option>
                                            <option value="1"><1</option>
                                            <option value="2"><2</option>
                                            <option value="3"><3</option>
                                            <option value="4"><4</option>
                                            <option value="5"><5</option>
                                            <option value="6"><6</option>
                                            <option value="7"><7</option>
                                            <option value="8"><8</option>
                                            <option value="9"><9</option>
                                            <option value="10"><10</option>
                                            <option value="11">>10</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab1addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab1')">
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>

            </table>

            <p class="note">Candidate Skill Experience - Optional</p>
            <table class="editTable" width="700">
                <tr>
                    <td colspan="4" class="tdVertical">
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="650" id="mytab2">
                                <?php if ($this->joborderOptionalSkills !== false): ?>
                                <?php foreach ($this->joborderOptionalSkills as $rowNumber => $contactsData): ?>
                                <tr>
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="23" class="inputbox" id="optionalskillname" name="optionalskillname[]" 
                                               style="width: 150px;" value="<?php $this->_($contactsData['skillname']) ?>">
                                    </td>
                                    <td width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">Exp.</label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="24" id="optionalskillnameexp" name="optionalskillnameexp[]" class="inputbox" style="width: 150px;">
                                            <option value="-1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '-1') echo('selected'); ?>>-Select from List-</option>
                                            <option value="1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '1') echo('selected'); ?>><1</option>
                                            <option value="2" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '2') echo('selected'); ?>><2</option>
                                            <option value="3" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '3') echo('selected'); ?>><3</option>
                                            <option value="4" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '4') echo('selected'); ?>><4</option>
                                            <option value="5" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '5') echo('selected'); ?>><5</option>
                                            <option value="6" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '6') echo('selected'); ?>><6</option>
                                            <option value="7" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '7') echo('selected'); ?>><7</option>
                                            <option value="8" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '8') echo('selected'); ?>><8</option>
                                            <option value="9" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '9') echo('selected'); ?>><9</option>
                                            <option value="10" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '10') echo('selected'); ?>><10</option>
                                            <option value="11" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '11') echo('selected'); ?>>>10</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab2addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab2')">
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                                <tr>
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Skill </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="23" class="inputbox" id="optionalskillname" name="optionalskillname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID">Exp.</label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="24" id="optionalskillnameexp" name="optionalskillnameexp[]" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                            <option value="1"><1</option>
                                            <option value="2"><2</option>
                                            <option value="3"><3</option>
                                            <option value="4"><4</option>
                                            <option value="5"><5</option>
                                            <option value="6"><6</option>
                                            <option value="7"><7</option>
                                            <option value="8"><8</option>
                                            <option value="9"><9</option>
                                            <option value="10"><10</option>
                                            <option value="11">>10</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input  type="button" class="button" value="Add" onclick="mytab2addRow(this)">
                                        <input  type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab2')">
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
                        <div style="margin-left: 5px;">
                            <table class="editTable" width="650" id="mytab3">
                                <?php if ($this->jobOrderCertifications !== false): ?>
                                <?php foreach ($this->jobOrderCertifications as $rowNumber => $contactsData): ?>
                                <tr>
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Certification </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="25" class="inputbox" id="certificationname" name="certificationname[]" 
                                               style="width: 150px;" value="<?php $this->_($contactsData['skillname']) ?>">
                                    </td>
                                    <td  width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID"></label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="26" id="certificationcategory" name="certificationcategory[]" class="inputbox" style="width: 150px;">
                                            <option value="-1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '-1') echo('selected'); ?>>-Select from List-</option>
                                            <option value="1" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '1') echo('selected'); ?>>Mandatory</option>
                                            <option value="0" <?php if (strtolower($this->_($contactsData['skillexprience'])) == '0') echo('selected'); ?>>Optional</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input type="button" class="button" value="Add" onclick="mytab3addRow(this)">
                                        <input type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab3')">
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                                <?php endif; ?>
                                <tr>
                                    <td width="10%" class="tdVertical">
                                        <label id="durationLabel" for="duration">Certification </label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <input type="text" tabindex="25" class="inputbox" id="certificationname" name="certificationname[]" 
                                               style="width: 150px;" value="">
                                    </td>
                                    <td  width="10%" class="tdVertical">
                                        <label id="openingsIDLabel" for="openingsID"></label>
                                    </td>
                                    <td width="30%" class="tdData">
                                        <select tabindex="26" id="certificationcategory" name="certificationcategory[]" class="inputbox" style="width: 150px;">
                                            <option value="-1">-Select from List-</option>
                                            <option value="1">Mandatory</option>
                                            <option value="0">Optional</option>
                                        </select>
                                    </td>
                                    <td width="20%">
                                        <input type="button" class="button" value="Add" onclick="mytab3addRow(this)">
                                        <input type="button" class="button" value="Remove" onclick="removeRow(this, 'mytab3')">
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
                        <textarea tabindex="27" class="mceEditor" name="description" id="description" rows="15" style="width: 500px;"><?php if(isset($this->jobOrderSourceRS['description'])): ?><?php $this->_($this->jobOrderSourceRS['description']); ?><?php endif; ?></textarea>
                    </td>
                </tr>

                <tr>
                    <td class="tdVertical">
                        <label id="notesLabel" for="notes">Internal Notes:</label>
                    </td>
                    <td class="tdData">
                        <textarea tabindex="28" class="mceEditor" name="notes" id="notes" rows="5" style="width: 500px;"><?php if(isset($this->jobOrderSourceRS['notes'])): ?><?php $this->_($this->jobOrderSourceRS['notes']); ?><?php endif; ?></textarea>
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

            <input type="submit" tabindex="22" class="button" name="submit" id="submit" value="Save" />&nbsp;
            <input type="reset"  tabindex="23" class="button" name="reset"  id="reset"  value="Reset" />&nbsp;
            <input type="button" tabindex="24" class="button" name="back"   id="back"   value="Back to Details" onclick="javascript:goToURL('<?php echo(CATSUtility::getIndexName()); ?>?m=joborders&amp;a=show&amp;jobOrderID=<?php echo($this->jobOrderID); ?>');" />
        </form>

        <script type="text/javascript">
            document.editJobOrderForm.title.focus();
        </script>
    </div>
</div>
<div id="bottomShadow"></div>
<?php TemplateUtility::printFooter(); ?>
