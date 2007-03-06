<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<openmrs:require privilege="View Observations" otherwise="/login.htm"
	redirect="/dictionary/conceptStats.form" />

<style>
	#newSearchForm {
		padding: 0px;
		margin: 0px;
		display: inline;
	}
	#conceptTable th {
		text-align: left;
	}
	#conceptNameTable th {
		text-align: left;	
	}
	#outliers {
		height: 100px;
		overflow: auto;
	}
</style>

<script type="text/javascript">

	function hotkeys(event) {
		var k = event.keyCode;
		if (event.cntrlKey == true) {
			if (k == 69) { // e
				document.location = document.getElementById('editConcept').href;
			}
		}
		if (k == 37) { // left key
			document.location = document.getElementById('previousConcept').href;
		}
		else if (k == 39) { //right key
			document.location = document.getElementById('nextConcept').href;
		}
	}
	
	document.onkeypress = hotkeys;
	
	function showHideOutliers(btn) {
		var table = document.getElementById("outliers");
		if (btn.innerHTML == '<spring:message code="Concept.stats.histogram.showOutliers"/>') {
			table.style.display = "";
			btn.innerHTML = '<spring:message code="Concept.stats.histogram.hideOutliers"/>';
		}
		else {
			table.style.display = "none";
			btn.innerHTML = '<spring:message code="Concept.stats.histogram.showOutliers"/>';
		}
		return false;
	}

</script>

<h2><spring:message code="Concept.stats.title" arguments="${concept.name}" /></h2>

<c:if test="${concept.conceptId != null}">
	<c:if test="${previousConcept != null}"><a href="concept.htm?conceptId=${previousConcept.conceptId}" id="previousConcept" valign="middle"><spring:message code="general.previous"/></a> |</c:if>
	<a href="concept.htm?conceptId=${concept.conceptId}" id="viewConcept" ><spring:message code="general.view"/></a> |
	<openmrs:hasPrivilege privilege="Edit Concepts"><a href="concept.form?conceptId=${concept.conceptId}" id="editConcept" valign="middle"></openmrs:hasPrivilege><spring:message code="general.edit"/><openmrs:hasPrivilege privilege="Edit Concepts"></a></openmrs:hasPrivilege> |
	<c:if test="${nextConcept != null}"><a href="concept.htm?conceptId=${nextConcept.conceptId}" id="nextConcept" valign="middle"><spring:message code="general.next"/></a></c:if> |
</c:if>

<openmrs:hasPrivilege privilege="Edit Concepts"><a href="concept.form" id="newConcept" valign="middle"></openmrs:hasPrivilege><spring:message code="general.new"/><openmrs:hasPrivilege privilege="Edit Concepts"></a></openmrs:hasPrivilege>

<openmrs:extensionPoint pointId="org.openmrs.dictionary.conceptFormHeader" type="html" />

<form id="newSearchForm" action="index.htm" method="get">
  &nbsp; &nbsp; &nbsp;
  <input type="text" id="searchPhrase" name="phrase" size="18"> 
  <input type="submit" class="smallButton" value="<spring:message code="general.search"/>"/>
</form>

<br/><br/>
<c:if test="${concept.retired}">
	<div class="retiredMessage"><div><spring:message code="Concept.retiredMessage"/></div></div>
</c:if>

<c:choose>
	<c:when test="${displayType == 'numeric'}">
		<table>
			<tr>
				<td><spring:message code="Concept.stats.numberObs"/></td>
				<td>${fn:length(obsNumerics)}</td>
			</tr>
			<c:if test="${fn:length(obsNumerics) > 0}">
				<tr>
					<td><spring:message code="Concept.stats.minValue"/></td>
					<td>${min}</td>
				</tr>
				<tr>
					<td><spring:message code="Concept.stats.maxValue"/></td>
					<td>${max}</td>
				</tr>
				<tr>
					<td><spring:message code="Concept.stats.meanValue"/></td>
					<td>${mean}</td>
				</tr>
				<tr>
					<td><spring:message code="Concept.stats.medianValue"/></td>
					<td>${median}</td>
				</tr>
				<tr>
					<td valign="top"><spring:message code="Concept.stats.histogram"/></td>
					<td>
						<openmrs:displayChart chart="${histogram}" width="800" height="300" />
					</td>
				</tr>
				<tr>
					<td valign="top"><spring:message code="Concept.stats.histogramOutliers"/></td>
					<td>
						<openmrs:displayChart chart="${histogramOutliers}" width="800" height="300" />
						<br/> <a href="#" onclick="return showHideOutliers(this)"><spring:message code="Concept.stats.histogram.showOutliers"/></a> (<c:out value="${fn:length(outliers)}"/>)
						<br/>
						<div id="outliers" style="display: none">
							<table>
							<c:forEach items="${outliers}" var="outlier">
								<tr>
									<td><a target="_edit_obs" href="${pageContext.request.contextPath}/admin/observations/obs.form?obsId=${outlier[0]}">
										<spring:message code="general.edit"/></a>
									</td>
									<td><b>${outlier[2]}</b></td>
									<td>(${outlier[1]})</td>
								</tr>
							</c:forEach>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td valign="top"><spring:message code="Concept.stats.timeSeries"/></td>
					<td>
						<openmrs:displayChart chart="${timeSeries}" width="800" height="300" />
					</td>
				</tr>
			</c:if>
		</table>
	</c:when>
	<c:when test="${displayType == 'boolean'}">
		<i> Not completed yet </i>
	</c:when>
	<c:when test="${displayType == 'coded'}">
		<table>
			<tr>
				<td valign="top"><spring:message code="Concept.stats.codedPieChart"/></td>
				<td>
					<openmrs:displayChart chart="${pieChart}" width="700" height="700" />
				</td>
			</tr>
		</table>
	</c:when>
	<c:otherwise>
		<spring:message code="Concept.stats.notDisplayable"/>
	</c:otherwise>
</c:choose>
	
<%@ include file="/WEB-INF/template/footer.jsp"%>
