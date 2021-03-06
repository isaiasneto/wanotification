{extends file="head.tpl"}
{block name=body}
<div class="container-fluid">
	<div class="row">
		<div class="col-xs-10 col-md-12 col-center">
			<div class="row">
				<div class="col-xs-12 col-md-6 col-center">
 					{include file="body-banner.tpl"}
 				</div>
 			</div>
 			<div class="row">
				<div class="col-xs-12 col-md-6 col-center">
					<a href="/home" id="bthome" class="btn btn-coke pull-left"><i class="fa fa-arrow-circle-left"></i> Voltar</a>
					<div class="col-xs-4 col-md-8">
						<div class="form-group">
							<input class="form-control search-input" type="text" id="search" name="search" placeholder="&#xf002;" autocomplete="off"/>
						</div>
					</div>
					<a href="/alerts/add" id="btnadd" class="btn btn-coke pull-right"><i class="fa fa-plus-circle"></i> Adicionar</a>
				</div>
 			</div>
			<div class="row">
				<div class="col-xs-12 col-md-6 col-center" style="height: 400px; overflow-y: auto; overflow-x: hidden">
					<div id="list" class="list-group">
						{foreach from=$alerts item=alert}
							<button id="{$alert.id_group}" type="button" class="list-group-item" data-toggle="tooltip" data-placement="top" title="ID:{$alert.id_alert}">
								{$alert.name}
							</button>
						{/foreach}
					</div>
					<div id="contact" class="panel panel-default" style="display: none;">
						<div class="panel-body">
							<div class="media">
								<div class="media-left media-heading">
									<a>
										<img id="mediai" class="media-object" style="width: 50px" src="/asset/img/fa-users.png" alt="...">
									</a>
								</div>
								<div class="media-body">
									<h4 id="mediah" class="media-heading">
										<input class="form-control-textonly hide" disabled id="idgroup" name="idgroup"></input>
										<input class="form-control-textonly" disabled id="mname" name="mname" maxlength="25"></input>
									</h4>
									<div id="listgroup" class="list-group">
									</div>
									<span id="delmsg" class="text-muted help-block" style="display: none">Marque o usuário que deseja excluir do grupo.</span>
									<button id="btndel" class="btn btn-sm btn-coke" data-toggle="tooltip" data-placement="bottom" title="Apagar"><span class="fa fa-trash"></span></button>
									<button id="btnaddsm" class="btn btn-sm btn-primary" data-toggle="tooltip" data-placement="bottom" title="Adicionar membro" style="display: none;"><span class="fa fa-plus-circle"></span></button>
									<button id="btnedit" class="btn btn-sm btn-coke" data-toggle="tooltip" data-placement="bottom" title="Editar"><span class="fa fa-pencil"></span></button>
									<button id="btncheck" class="btn btn-sm btn-success" data-toggle="tooltip" data-placement="bottom" title="Confirmar alterações" style="display: none;"><span class="fa fa-check-circle"></span></button>
									<button id="btnback" class="btn btn-sm btn-coke" data-toggle="tooltip" data-placement="bottom" title="Voltar"><span class="fa fa-chevron-circle-left"></span></button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="delmodal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="delmodal">
	<div class="modal-dialog modal-sm" role="document">
		<div class="modal-content">
			<div class="modal-body">
				<h4>Tem certeza que deseja apagar?</h4>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Não</button>
				<button id="delcheck" type="button" class="btn btn-primary">Sim</button>
			</div>
		</div>
	</div>
</div>

<div id="addmodal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addmodal">
	<div class="modal-dialog modal-md" role="document">
		<div class="modal-content">
			<div class="modal-body">
				<div class="panel panel-default">
					<div class="panel-heading">
						<div class="input-group">
							<div class="input-group-addon"><span class="fa fa-user-plus"></span></div>
							<input class="form-control  search-input" type="text" id="searchmodal" name="search" placeholder="&#xf002;" autocomplete="off"/>
						</div>
					</div>
					<ul id="listgroupadd" class="list-group" style="height: 300px; overflow-y: auto; overflow-x: hidden">
					</ul>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
				<button id="btnaddmodal" type="button" class="btn btn-primary">Adicionar</button>
			</div>
		</div>
	</div>
</div>

{literal}
<script type="text/javascript">
	$(document).ready(function () {
		var id, idgroup, txtname;
		var idscontacs = [];
		var idsex = [];
		var contactsadd = [];

		$('[data-toggle="tooltip"]').tooltip();

		$('#search').on('keyup click input', function () {
			if (this.value.length > 0) {
				$('#list').children('.list-group-item').hide().filter(function () {
					return $(this).text().toLowerCase().indexOf($('#search').val().toLowerCase()) != -1;
				}).show();
			} else {
				$('.list-group-item').show();
			}
		});

		$('#searchmodal').on('keyup click input', function () {
			if (this.value.length > 0) {
				$('#listgroupadd').children('.list-group-item').hide().filter(function () {
					return $(this).text().toLowerCase().indexOf($('#searchmodal').val().toLowerCase()) != -1;
				}).show();
			} else {
				$('.list-group-item').show();
			}
		});

		$('#list').children('button').click(function(event) {
			id = event.target.id;
			txtname = event.target.innerText;
			$('#idgroup').val(id);
			$('#mname').val(txtname);
			mnamew = ((txtname.length + 1) * 8) + 'px';
			$('#mname').css('width', mnamew);
			$.get('/groups/group_members/'+id,
			function(data, textStatus, xhr) {
				for (var i = 0; i < data.length; i++) {
					$('#listgroup').append('<li id="li'+data[i].id_contact+'" class="list-group-item"><input id="'+data[i].id_contact+'" style="display: none" type="checkbox"/> '+data[i].name+' '+data[i].surname+'</li>');
					// $('#listgroup').append('<li class="list-group-item"><i  id="'+data[i].id_contact+'" style="display: none" class="fa fa-minus-circle"></i> '+data[i].name+' '+data[i].surname+'</li>');
				}
			});
			idgroup = $('#idgroup').val();
			$('#list').hide();
			$('#contact').fadeIn('fast');
		});

		$('#btndel').click(function() {
			$('#delmodal').modal('show');
		});

		$('#delcheck').click(function() {
			idval = $('#idgroup').val();
			$.post('/groups/del', {
				id_group: idval
			},
			function(data, textStatus, xhr) {
				$('#'+idval).remove();
				$('#contact').hide();
				$('#list').fadeIn('fast');
				$('#delmodal').modal('toggle');
			});
		});

		$('#addmodal').on('shown.bs.modal', function () {
			$('#listgroupadd').children('li').children("input[type='checkbox']").click(function(event) {
				selectedid = event.target.id;
				cbchecked = event.currentTarget.attributes[1].ownerElement.checked;
				if (cbchecked) {
					contactsadd.push(selectedid);
				} else {
					contactsadd.splice(contactsadd.indexOf(selectedid),1);
				}
			});
			$('#btnaddmodal').click(function() {
				for (var i = 0; i < contactsadd.length; i++) {
					currid = contactsadd[i];
					fullname = $('#listgroupadd').children('li').children('#'+currid).html();
					// $('#listgroup').append('<li class="list-group-item"><input id="'+data[i].id_contact+'" style="display: none" type="checkbox"/> '+data[i].name+' '+data[i].surname+'</li>');
				}	
				$.post('/groups/add_member', {
					id_group: idgroup,
					id_contacts: contactsadd
				},
				function(data, textStatus, xhr) {
					console.log(data);
					for (var i = 0; i < contactsadd.length; i++) {
						idil = contactsadd[i];
						console.log(idil);
						fullname = $('#listgroupadd').children('li').children('#'+idil).parent('li').text();
						$('#listgroup').append('<li id="li'+idil+'" class="list-group-item"><input id="'+idil+'" style="display: none" type="checkbox"/>'+fullname+'</li>');
					}
				});
				$('#addmodal').modal('toggle');
			});
		})

		$("#btnedit").click(function() {
			idsgroup = $("input[type='checkbox']");
			totalids = idsgroup.length;
			for (var i = 0; i < totalids; i++) {
				idsex.push(idsgroup[i].id);
			}
			$("input[type='checkbox']").click(function(event) {
				idc = event.target.id;
				cbchecked = event.currentTarget.attributes[1].ownerElement.checked;
				if (cbchecked) {
					idscontacs.push(idc);
				} else {
					idscontacs.splice(idscontacs.indexOf(idc),1);
				}
				if (idscontacs.length == totalids) {
					alert('O grupo deve contar no mínimo um membro!');
					$('#listgroup').children('li').children('#'+idc).prop('checked', false);
				}
			});
			$('#mname').removeClass('form-control-textonly');
			$('#mname').removeAttr('disabled');
			$('#mname').addClass('form-control-text');
			$('#listgroup').children('li').children('input').fadeIn('fast');
			$('#delmsg').fadeIn('fast');
			// $('#listgroup').children('li').children('i').fadeIn('fast');
			$('#btndel').hide();
			$('#btnedit').hide();
			$('#btnaddsm').fadeIn('fast');
			$('#btncheck').fadeIn('fast');
			$('#mname').focus();
		});

		$('#btnaddsm').click(function() {
			$('#listgroupadd').html(null);
			$.get('/contacts/listex', {
				idsex: idsex
			},
			function(data, textStatus, xhr) {
				for (var i = 0; i < data.length; i++) {
					$('#listgroupadd').append('<li class="list-group-item"><input id="'+data[i].id_contact+'" type="checkbox"/> '+data[i].name+' '+data[i].surname+'</li>');
				}
			});
			$('#addmodal').modal('show');
		});

		$("#btncheck").click(function() {
			idval = $('#idgroup').val();
			nameval = $('#mname').val();
			$('#mname').removeClass('form-control-text');
			$('#mname').attr('disabled', 'true');
			$('#mname').addClass('form-control-textonly');
			$('#iconedit').removeClass('fa-check-circle');
			$.post('/groups/edit', {
				id_group: idval,
				name: nameval
			},
			function(data, textStatus, xhr) {
				console.log(data);
			});
			if (idscontacs.length >= 1) {
				$.post('/groups/del_member', {
					id_group: idval,
					id_contacts: idscontacs
				},
				function(data, textStatus, xhr) {
					console.log(data);
					for (var i = 0; i < idscontacs.length; i++) {
						idc = idscontacs[i];
						// $('#listgroup').children('#li'+idc).slideUp('fast');
						$('#listgroup').children('#li'+idc).remove();
						// console.log(idc);
					}
				});
			}
			// $('#listgroup').children('li').children('input').remove();	
			$('#listgroup').children('li').children('input').fadeOut(100);
			// $('#listgroup').children('li').children('i').fadeOut(100);
			$('#delmsg').fadeOut(100);
			$('#'+idval).text(nameval);
			$('#iconedit').addClass('fa-pencil');
			$('#btnaddsm').hide();
			$('#btncheck').hide();
			$('#btndel').fadeIn('fast');
			$('#btnedit').fadeIn('fast');
		});

		$('#btnback').click(function() {
			$('#mname').removeClass('form-control-text');
			$('#msurname').removeClass('form-control-text');
			$('#mname').attr('disabled', 'true');
			$('#msurname').attr('disabled', 'true');
			$('#mname').addClass('form-control-textonly');
			$('#msurname').addClass('form-control-textonly');
			$('#iconedit').removeClass('fa-check-circle');
			$('#iconedit').addClass('fa-pencil');
			$('#listgroup').html(null);
			$('#contact').hide();
			$('#list').fadeIn('fast');
		});
	});
</script>
{/literal}
{/block}