<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>

	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Tables</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					Board Register Page
				</div>
                 <!-- /.panel-heading -->
                 
                 <div class="panel-body">
                 <form role="form" action="/board/register" method="post">
                 <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
                 	
                 	<div class="form-group">
                 		<label>Title</label>
                 		<input class="form-control" name="title">
                 	</div>
                 	
                 	<div class="form-group">
                 		<label>Text area</label>
                 		<textarea class="form-control" rows="3" name="content"></textarea>
                 	</div>
                 	
                 	<div class="form-group">
                 		<label>writer</label>
                 		<input class="form-control" name="writer" readonly="readonly"
                 			value='<sec:authentication property="principal.username"/>'>
                 	</div>
                 	
                 	<button type="submit" class="btn btn-default">Submit Button</button>
                 	<button type="reset" class="btn btn-default">Reset Button</button>
                 	
                 </form>
				</div>
            	<!-- /.panel-body -->
			</div>	
        	<!-- /.panel -->
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	
	<!-- 새로 추가되는 부분, 첨부파일 등록 처리 -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">file Attach</div>
				
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple>
					</div>
					
					<div class="uploadResult">
						<ul>
						
						</ul>
					</div>
				</div>
				<!-- end panel-body -->
			</div>
		</div>
	</div>
	
	<script>
	$(document).ready(function(e){
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit clicked");
			var str = "";
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' ";
				str += "value='"+ jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' ";
				str += "value='"+ jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' ";
				str += "value='"+ jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' ";
				str += "value='"+ jobj.data("type")+"'>";
				
			});
			formObj.append(str).submit();
		});
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; // 5MB
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 크기 초과");
				return false;
			}
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("input[type='file']").change(function(e) {
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			for(var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size) ) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url : "/uploadAjaxAction",
				processData : false,
				contentType : false,
				beforeSend : function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data : formData,
				type : "POST",
				dataType : 'json',
				success : function(result) {
					console.log(result);
					showUploadResult(result); // 업로드 결과 처리 함수
				}
			}); // $.ajax
		});
		
		// 생성된 이미지에 클릭 이벤트 위임하기 (delegate)
		$(".uploadResult").on("click", "button", function(e) {
			console.log("delete file");
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var targetLi = $(this).closest("li");
			$.ajax({
				url : '/deleteFile',
				data : {fileName : targetFile, type : type},
				beforeSend : function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType : 'text',
				type : 'POST',
				success : function(result) {
					alert(result);
					targetLi.remove();
				}
			}); // $.ajax
		});
		
	});
	
	function showUploadResult(uploadResultArr) {
		if(!uploadResultArr || uploadResultArr.length == 0) {return;}
		var uploadUL = $(".uploadResult ul");
		var str = "";
		$(uploadResultArr).each(function(i, obj){
			// image type
			if(obj.fileType) {
				var fileCellPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
				str += " data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><div>";
				str += "<span>"+obj.fileName+"</span>";
				str += "<button type='button' data-file='"+fileCellPath +"' data-type='image'" ;
				str += " class='btn btn-warning btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCellPath+"'></div></li>";
			} else {
				var fileCellPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink = fileCellPath.replace(new RegExp(/\\/g), "/");
				str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
				str += " data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><div>";
				str += "<span> " + obj.fileName + "</span>";
				str += "<button type='button' data-file='"+fileCellPath +"' data-type='file'" ;
				str += " class='btn btn-warning btn-circle'>";
				str += "<i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'></div></li>";
			}				
		});
		uploadUL.append(str);
	}
	
	</script>
	
	<style>
	img{width : 100px; height : 100px; }
	</style>
	
	<!-- Javascript 처리 -->
<%@include file="../includes/footer.jsp" %>