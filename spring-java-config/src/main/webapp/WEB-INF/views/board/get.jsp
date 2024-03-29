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
					Board Read Page
				</div>
                 <!-- /.panel-heading -->
                 
                 <div class="panel-body">
                 
                 	<div class="form-group">
                 		<label>Bno</label>
                 		<input class="form-control" name="seq_bno" 
                 			value='<c:out value="${board.seq_bno }" />' readonly="readonly">
                 	</div>
                 	
                 	<div class="form-group">
                 		<label>Title</label>
                 		<input class="form-control" name="title"
                 			value='<c:out value="${board.title }" />' readonly="readonly">
                 	</div>
                 	
                 	<div class="form-group">
                 		<label>Text area</label>
                 		<textarea class="form-control" rows="3" name="content" readonly="readonly">
                 		<c:out value="${board.content }"/></textarea>
                 	</div>
                 	
                 	<div class="form-group">
                 		<label>writer</label>
                 		<input class="form-control" name="writer"
                 			value='<c:out value="${board.writer }" />' readonly="readonly">
                 	</div>
                 	
                 	<sec:authentication property="principal" var="pinfo"/>
                 	<sec:authorize access="isAuthenticated()">
                 	<c:if test="${pinfo.username eq board.writer }">
                 		<button data-oper="modify" class="btn btn-default">Modify</button>
                 	</c:if>
                 	</sec:authorize> 

                 	<button data-oper="list" class="btn btn-default">List</button>
                 	
                 	 <form id="openForm" action="/board/modify" method="get">
                 	 	<input type="hidden" id="seq_bno" name="seq_bno"
                 	 		 value='<c:out value="${board.seq_bno }" />' />
                 	 	<input type="hidden" name="pageNum" 
                 	 		value='<c:out value="${cri.pageNum }"/>' />
                	 	<input type="hidden" name="amount" 
                 	 		value='<c:out value="${cri.amount }"/>' />
                 	 	<input type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
                        <input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"/>'>
                 	 </form>
                 	 
				</div>
            	<!-- /.panel-body -->
			</div>	
        	<!-- /.panel -->
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	
	<!-- file이 보여질 영역 -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">files</div>
				<div class="panel-body">
					<div class="uploadResult">
						<ul>
						
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- /.row -->
	
	<!-- 댓글 영역 -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i> Reply
					<sec:authorize access="isAuthenticated()">
					<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
					</sec:authorize>
				</div>
				 
				<div class="panel-body">
					<ul class="chat">
						<!-- reply 
						<li class="left clearfix" data-seq_rno='3'>
							<div>
								<div class="header">
									<strong class="primary-font">user00</strong>
									<small class="pull-right text-muted">2021-08-11 23:00</small>
								</div>
								<p>Good job!</p>
							</div>
						</li> -->
					</ul>
				</div>
				<!-- /.panel-body -->
				
				<div class="panel-footer"> 
				
				</div>
			</div>
			<!-- /.panel -->
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	
	<!-- /. 댓글 영역 -->
	
	 <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                    	<label>Reply</label>
                    	<input class="form-control" name='reply' value='New Reply'>
                    </div>
                    <div class="form-group">
                    	<label>Replyer</label>
                    	<input class="form-control" name='replyer' value='replyer' readonly="readonly">
                    </div>
                    <div class="form-group">
                    	<label>Reply Date</label>
                    	<input class="form-control" name='replyDate' value=''>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                    <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                    <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                    <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
	
	<script type="text/javascript" src="/resources/js/reply.js"></script>
	
	<script type="text/javascript">
	$(document).ready(function() {	
		var seq_bno = '<c:out value="${board.seq_bno}"/>';
		var replyUL = $(".chat");
		
		showList(1);
		
		function showList(page) {
			replyService.getList({seq_bno:seq_bno, page : page || 1}, 
					function(replyCnt, list) {
				
				if(page == -1) {
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				var str = "";
				if(list == null || list.length == 0) {
					//replyUL.html(str);
					return;
				}
				for( var i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class='left clearfix' data-seq_rno='"+ list[i].seq_rno +"'>";
					str += "<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
					str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].updateDate)+"</small>";
					str += "</div><p>"+ list[i].reply +"</p></div></li>";
				}
				
				replyUL.html(str);
				showReplyPage(replyCnt);
			});
		} // showList
		
		// 2021-08-13 댓글 모달 관련 
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn = $("#modalCloseBtn");
		
		var replyer = null;
		
		<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username" />';
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);	
		});
		
		$("#addReplyBtn").on("click", function(e) {
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[ id != 'modalCloseBtn']").hide();
			modalRegisterBtn.show();
			
			modal.modal("show");
		});
		
		modalRegisterBtn.on("click", function(e) {
			var reply = {
				reply : modalInputReply.val(),
				replyer : modalInputReplyer.val(),
				seq_bno : seq_bno
			};
			replyService.add(reply, function(result) {
				alert(result);
				modal.find("input").val("");
				modal.modal("hide");
				//showList(1);
				showList(-1);
			});
		});
		
		// 댓글 항목 li에 click 이벤트 위임
		$(".chat").on("click", "li", function(e) {
			var seq_rno = $(this).data("seq_rno");
			
			pageNum = $("li.active > a").html();
			console.log("pageNum : "+ pageNum);
			
			replyService.get(seq_rno, function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.updateDate))
				.attr("readonly", "readonly");
				modal.data("seq_rno", reply.seq_rno);
				
				modal.find("button[ id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				modal.modal("show");
			});
		});
		
		// 댓글 수정
		modalModBtn.on("click", function(e) {
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {
					seq_rno : modal.data("seq_rno"),
					reply : modalInputReply.val(),
					replyer : originalReplyer};
			
			if(!replyer) {
				alert("로그인 후 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			console.log("Original Replyer : " + originalReplyer);
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		}); 

		// 삭제
		modalRemoveBtn.on("click", function(e) {
			var seq_rno = modal.data("seq_rno");
			
			if(!replyer) {
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			var originalReplyer = modalInputReplyer.val();
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
				
			replyService.remove(seq_rno, originalReplyer, function(result) {
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		}); 
		
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt) {
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt) {
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			
			if(prev) {
				str += "<li class='page-item'><a class='page-link' href='" + (startNum-1) +"'>Previous</a></li>";
			}
			
			for(var i = startNum ; i <= endNum ; i++) {
				var active = pageNum == i ? "active":"";
				str += "<li class='page-item " +active+ " '><a class='page-link' href='" + i + "'>" + i +"</a></li>";
			}
			
			if(next) {
				str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) +"'>Next</a></li>";
			}
			
			str += "</ul></div>";
			console.log(str)
			replyPageFooter.html(str);
		}
		
		replyPageFooter.on("click", "li a",function(e) {
			e.preventDefault();
			console.log("page click");
			
			var targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum : " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		});		
	});
	
	/* 테스트 
	console.log("======================================");
	console.log("JS TEST");
	$(document).ready(function() {	
		console.log(replyService);
	});
	
	replyService.get(13 , function(data) {
		console.log(data);
	});
	
	*/
	// 2번 댓글 수정
	/*
	replyService.update({
		seq_rno : 2,
		seq_bno : seq_bno, // 777로 테스트
		reply : "Modified Reply..."
	}, function(result) {
		alert("수정 완료...");
	});
	*/
	
	// 8번 댓글 삭제 테스트
	/*
	replyService.remove(8, function(count) {
		console.log(count);
		if(count === "success") {
			alert("REMOVE");
		}
	}, function(err) {
		alert("ERROR...");
	});
	*/
	// for replyService getList test
	/*
	replyService.getList({seq_bno:seq_bno, page:1}, function(list) {
		for(var i = 0, len = list.length||0; i < len; i++) {
			console.log(list[i]);
		}
	});
	*/
	
	// for replyService add test
	/*
	replyService.add(
		{reply : "JS Test", replyer : "tester", seq_bno:seq_bno}
		,
		function(result) {
			alert("RESULT : "+result);
		}
	);
	*/
	
	</script>
	
	<script type="text/javascript">
	$(document).ready(function() {	
		var openForm = $("#openForm");
		$("button[data-oper='modify']").on("click", function(e) {
			openForm.attr("action", "/board/modify").submit();
		});
		$("button[data-oper='list']").on("click", function(e) {
			openForm.find("#seq_bno").remove();
			openForm.attr("action", "/board/list").submit();
		});
	});
	</script>
	
	<script type="text/javascript">
	// 파일 리스트를 가져오는 자동 동작 처리 작업
	$(document).ready(function() {
		(function() {
			var seq_bno = '<c:out value="${board.seq_bno}"/>';
			
			$.getJSON("/board/getAttachList", {seq_bno : seq_bno}, function(arr){
				console.log(arr);
				var str = "";
				$(arr).each(function(i, attach){
					// image type
					if(attach.fileType) {
						var fileCellPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"'";
						str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
						str += "<img src='/display?fileName="+fileCellPath+"'></div></li>";
					} else {
						//var fileCellPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						//var fileLink = fileCellPath.replace(new RegExp(/\\/g), "/");
						str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"'";
						str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
						
						str += "<span> " + attach.fileName + "</span>";
						str += "<img src='/resources/img/attach.png'></div></li>";
					}
				});
				$(".uploadResult ul").html(str);
			}); // end getJson
		})();
		
		// 첨부파일 클릭 이벤트
		$(".uploadResult").on("click", "li", function(e){
			console.log("view image");
			var liObj = $(this);
			var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
			if(liObj.data("type")) {
				showImage(path.replace(new RegExp(/\\/g), "/"));
			} else {
				// download
				self.location = "/download?fileName="+path
			}
		});
		function showImage(fileCellPath) {
			alert(fileCellPath);
			$("body").append("<div class='temp'><img src='/display?fileName="+fileCellPath+"'></div>")
			setTimeout(function() {
				$(".temp").remove();
			}, 5000);
		}
		
		// 원본 이미지 창 닫기
		$("body").on("click", "div.temp", function(e){
			$(this).remove();
		});
	});
	</script>
	<style>
	div.uploadResult li { float: left; list-style: none; border: 1px gray solid; margin-right: 10px;}
	div.uploadResult img {width : 100px; height: 100px; }
	div.temp{z-index: 10; position: fixed; left : 200px; top : 50px;}
	</style>
<%@include file="../includes/footer.jsp" %>