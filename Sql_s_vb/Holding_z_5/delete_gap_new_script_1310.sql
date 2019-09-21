alter procedure p_gap_del
@house_no varchar(100),
@qtr	  varchar(10)= null,
@amt	  float
with encryption
as
begin
declare @v_prev_due float
set @house_no=master.dbo.kccencrypt(ltrim(rtrim(@house_no)),11);
if @qtr is null
	begin
	delete from dbo.hv_Gap_Payment 
		where ltrim(rtrim(house_number))=@house_no
			--and ltrim(rtrim(fy_qtr))=ltrim(rtrim(@qtr))
	end
else
	begin
	delete from dbo.hv_Gap_Payment 
		where ltrim(rtrim(house_number))=ltrim(rtrim(@house_no))
			and ltrim(rtrim(fy_qtr))=ltrim(rtrim(@qtr))
	end


---Previous due update:-------------------------------------
	select @v_prev_due=prev_due from hv_holding01 
	where house_number=@house_no
	if @v_prev_due> 0
	begin
		set @v_prev_due=isnull(@v_prev_due,0)-@amt;
		if @v_prev_due<0 
			begin
			set @v_prev_due=0;
			end
	
		update data260
		set D260F13=master.dbo.kccencrypt(convert(varchar,@v_prev_due),11)
		where D260F1=@house_no;
	end
---------------------------------------------------------------------
	delete from billbook 
	where house_no like substring(@house_no,1,11) + '%';
end

--exec p_gap_del '49-085-2011-39/2-0','','289.8'