<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="goods"  value="${goodsMap.goodsVO}"  />
<c:set var="imageList"  value="${goodsMap.imageList }"  />
<c:set var="reviewList"  value="${goodsMap.reviewList }"  />

 <%
     //치환 변수 선언합니다.
      pageContext.setAttribute("crcn", "\r\n"); // 개행문자
      pageContext.setAttribute("br", "<br/>"); //br 태그
%>  
<html>
<head>
<style>
#layer {
	z-index: 2;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
}

#popup {
	z-index: 3;
	position: fixed;
	text-align: center;
	left: 50%;
	top: 45%;
	width: 300px;
	height: 200px;
	background-color: #ccffff;
	border: 3px solid #87cb42;
	font-size:medium; 
}

#close {
	z-index: 4;
	float: right;
}
</style>
<script type="text/javascript">
	// 장바구니 추가
	function add_cart(goods_id) {
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/cart/addGoodsInCart.do",
			data : {
				goods_id:goods_id
				
			},
			success : function(data, textStatus) {
				//alert(data);
			//	$('#message').append(data);
				if(data.trim()=='add_success'){
					imagePopup('open', '.layer01');	
				}else if(data.trim()=='already_existed'){
					alert("이미 카트에 등록된 상품입니다.");	
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}
	
	function add_review(goods_id, form) {
		
		var _isLogOn=document.getElementById("isLogOn");
		var isLogOn=_isLogOn.value;
		
		if(!isLogOn){
			alert("로그인 후 이용");
		}
		var review = form.review.value;
		var score = parseFloat(form.score.value);
		
		if(!(score >= 0.0 && score <=5.0)){
			alert("알맞은 범위의 평점을 적어주세요");
			return;
		}
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/goods/addReview.do",
			data : {
				goods_id : goods_id,
				score : score,
				review : review
			},
			success : function(data, textStatus) {
				//alert(data);
			//	$('#message').append(data);
				if(data.trim()=='add_success'){
					alert('작성 완료!!');
					location.reload();
				}
				else if(data.trim()=='add_fail'){
					alert('작성에 실패했습니다.');
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}
	
	

	function imagePopup(type) {
		if (type == 'open') {
			// 팝업창을 연다.
			jQuery('#layer').attr('style', 'visibility:visible');

			// 페이지를 가리기위한 레이어 영역의 높이를 페이지 전체의 높이와 같게 한다.
			jQuery('#layer').height(jQuery(document).height());
		}

		else if (type == 'close') {

			// 팝업창을 닫는다.
			jQuery('#layer').attr('style', 'visibility:hidden');
		}
	}
	
function fn_order_each_goods(goods_id,goods_title,goods_sales_price,fileName){
	var _isLogOn=document.getElementById("isLogOn");
	var isLogOn=_isLogOn.value;	
	// <hidden>태그의 id로 로그인 상태를 가져옴
	
	 if(isLogOn=="false" || isLogOn=='' ){
		alert("로그인 후 주문이 가능합니다!!!");
	}	// 로그인 상태를 확인 
	
	
	var total_price,final_total_price;
	var order_goods_qty=document.getElementById("order_goods_qty");
						// 상품 주문 개수를 가져옴
	var formObj=document.createElement("form");	// <form>태그를 동적으로 생성
	var i_goods_id = document.createElement("input"); 
    var i_goods_title = document.createElement("input");
    var i_goods_sales_price=document.createElement("input");
    var i_fileName=document.createElement("input");
    var i_order_goods_qty=document.createElement("input");
    // 주문 상품 정보를 전송할 <input>태그를 동적으로 생성
    
    i_goods_id.name="goods_id";
    i_goods_title.name="goods_title";
    i_goods_sales_price.name="goods_sales_price";
    i_fileName.name="goods_fileName";
    i_order_goods_qty.name="order_goods_qty";
    
    i_goods_id.value=goods_id;
    i_order_goods_qty.value=order_goods_qty.value;
    i_goods_title.value=goods_title;
    i_goods_sales_price.value=goods_sales_price;
    i_fileName.value=fileName;
    // <input>태그에 name/value로 값을 설정
    
    formObj.appendChild(i_goods_id);
    formObj.appendChild(i_goods_title);
    formObj.appendChild(i_goods_sales_price);
    formObj.appendChild(i_fileName);
    formObj.appendChild(i_order_goods_qty);
	// 동적으로 생성한 <input> 태그에 값을 설정한 후 다시 <form> 태그에 추가
    
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/order/orderEachGoods.do";	
    formObj.submit();
	}	// controller로 요청하면서 <input>태그의 값을 매개변수로 전달
</script>
</head>
<body>
	<hgroup>
		<h1>캠핑용품</h1>
	<!-- 	<h2>캠핑용품 &gt; 휴대용 &gt; 편의</h2> -->
		<h3>${goods.goods_title }</h3>
		<h4>${goods.goods_writer} &nbsp; 제조사| ${goods.goods_publisher}</h4>
	</hgroup>
	<div id="goods_image">
		<figure>
			<img alt="HTML5 &amp; CSS3"
				src="${contextPath}/thumbnails.do?goods_id=${goods.goods_id}&fileName=${goods.goods_fileName}">
		</figure>
	</div>
	<div id="detail_table">
		<table>
			<tbody>
				<tr>
					<td class="fixed">정가</td>
					<td class="active"><span >
					   <fmt:formatNumber  value="${goods.goods_price}" type="number" var="goods_price" />
				         ${goods_price}원
					</span></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">판매가</td>
					<td class="active"><span >
					   <fmt:formatNumber  value="${goods.goods_price*0.9}" type="number" var="discounted_price" />
				         ${discounted_price}원(10%할인)</span></td>
				</tr>
				<tr>
					<td class="fixed">포인트적립</td>
					<td class="active">${goods.goods_point}P(10%적립)</td>
				</tr>
			<!-- 	<tr class="dot_line">
					<td class="fixed">포인트 추가적립</td>
					<td class="fixed">만원이상 구매시 1,000P, 5만원이상 구매시 2,000P추가적립 편의점 배송 이용시 300P 추가적립</td>
				</tr> -->
				<tr>
					<td class="fixed">제조일</td>
					<td class="fixed">
					   <c:set var="pub_date" value="${goods.goods_published_date}" />
					   <c:set var="arr" value="${fn:split(pub_date,' ')}" />
					   <c:out value="${arr[0]}" />
					</td>
				</tr>
				<tr>
					<td class="fixed">재고 수량</td>
					<td class="fixed">${goods.goods_total_page}개</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">상품 번호</td>
					<td class="fixed">${goods.goods_isbn}</td>
				</tr>
				<tr>
					<td class="fixed">배송료</td>
					<td class="fixed"><strong>무료</strong></td>
				</tr>
				<tr>
					<td class="fixed">배송안내</td>
					<td class="fixed"><strong>[당일배송]</strong> 당일배송 서비스 시작!<br> <strong>[휴일배송]</strong>
						휴일에도 배송받는 캠핑샵</TD>
				</tr>
				<tr>
					<td class="fixed">도착예정일</td>
					<td class="fixed">지금 주문 시 내일 도착 예정</td>
				</tr>
				<tr>
					<td class="fixed">수량</td>
					<td class="fixed">
			      <select style="width: 60px;" id="order_goods_qty">
				      <option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option>
			     </select>
					 </td>
				</tr>
			</tbody>
		</table>
		<ul>
			<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_id }','${goods.goods_title }',
												'${goods.goods_sales_price}','${goods.goods_fileName}');">구매하기 </a></li>
												
			<li><a class="cart" href="javascript:add_cart('${goods.goods_id }')">장바구니</a></li>
			
			<!-- <li><a class="wish" href="#">위시리스트</a></li> -->
		</ul>
	</div>
	<div class="clear"></div>
	<!-- 내용 들어 가는 곳 -->
	<div id="container">
		<ul class="tabs">
			<li><a href="#tab1">상품 소개</a></li>
 			<!-- <li><a href="#tab2">저자소개</a></li>
			<li><a href="#tab3">책목차</a></li>
			<li><a href="#tab4">출판사서평</a></li>
			<li><a href="#tab5">추천사</a></li> -->
			<li><a href="#tab6">리뷰</a></li> 
			<li><a href="#tab7">리뷰 작성</a></li> 
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<h4>책소개</h4>
				<p>${fn:replace(goods.goods_intro,crcn,br)}</p>
				<c:forEach var="image" items="${imageList }">
					<img 
						src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.fileName}">
				</c:forEach>
			</div>
			<div class="tab_content" id="tab2">
				<h4>저자소개</h4>
				<p>
				<div class="writer">저자 : ${goods.goods_writer}</div>
				 <p>${fn:replace(goods.goods_writer_intro,crcn,br) }</p> 
				
			</div>
			<div class="tab_content" id="tab3">
				<h4>책목차</h4>
				<p>${fn:replace(goods.goods_contents_order,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab4">
				<h4>출판사서평</h4>
				 <p>${fn:replace(goods.goods_publisher_comment ,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab5">
				<h4>추천사</h4>
				<p>${fn:replace(goods.goods_recommendation,crcn,br) }</p>
			</div>
			<div class="tab_content" id="tab6">
				<table class="list_view">
					<tbody align=center >
					<tr>
						<td>글번호</td>
						<td>작성자</td>
						<td>리뷰</td>
						<td>평점</td>
						<td>작성일</td>
					</tr>
					<c:choose>
						<c:when test="${reviewList == null }">
							<tr height="10">
								<td colspan="4">
									<p align="center">
										<b><span style="font-size: 9pt;"> 등록된 글이 없습니다.</span></b>
									</p>
								</td>
							</tr>
						</c:when>
						<c:when test="${reviewList != null}">
							<c:forEach var="article" items="${reviewList }" varStatus="articleNum">
								<tr align="center">
									<td  width="5%">${article.num}</td>
									<td width="10%">${article.id }</td>
									<td align="left" width="35%">
										<span style="padding-right: 30px"></span>
										${article.review }
									</td>
									<td width="10%">
										${article.score }
									</td>
									<td width="10%">
										<fmt:formatDate value="${article.regDate }"/>
									</td>
								</tr>
							</c:forEach>
						</c:when>
					</c:choose>
					</tbody>
				</table>
			</div>
			<div class="tab_content" id="tab7">
				<form>
					<input type="text" size="20" name="score"> 
					<textarea rows="10" cols="100%" maxlength="2000" name="review"></textarea>
					<input type="button" value="리뷰 작성" onClick="add_review(${goods.goods_id},this.form)"/>
					<input type="reset" value="다시 작성"/>
				</form>

				
			</div>
			<%-- <div id="search" >
				<form name="frmSearch" action="${contextPath}/goods/searchGoods.do" >
					<input name="searchWord" class="main_input" type="text"  onKeyUp="keywordSearch()" placeholder="Search"> 
					<input type="submit" name="search" class="btn1"  value="검색">
				</form>
			</div> --%>
		</div>
	</div>
	<div class="clear"></div>
	<div id="layer" style="visibility: hidden">
		<!-- visibility:hidden 으로 설정하여 해당 div안의 모든것들을 가려둔다. -->
		<div id="popup">
			<!-- 팝업창 닫기 버튼 -->
			<a href="javascript:" onClick="javascript:imagePopup('close', '.layer01');"> <img
				src="${contextPath}/resources/image/close.png" id="close" />
			</a> <br /> <font size="12" id="contents">장바구니에 담았습니다.</font><br>
<form   action='${contextPath}/cart/myCartList.do'  >				
		<input  type="submit" value="장바구니 보기">
</form>			
</body>
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>